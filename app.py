from flask import Flask
from flask import url_for
from flask import request
from flask import redirect
from flask import render_template
from flask import session
from datetime import datetime
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import check_pwd
import math
import uuid

app = Flask(__name__)

app.secret_key = 'aHn6Zb7MstRxC8vEoF2zG3B9wQjKl5YD'

app.config['MYSQL_HOST'] = '13.239.32.219'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'qq584167495'
app.config['MYSQL_DB'] = 'carrent'
app.config['MYSQL_PORT'] = 3306

mysql = MySQL(app)


@app.route('/')
def index():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM Location;')
    account = cursor.fetchall()
    if 'loggedIn' in session:
        isStaff = session['is_staff']
        isSuperuser = session['is_superuser']
        return render_template("index.html", username=session['username'], locations=account, is_staff=isStaff, is_superuser=isSuperuser)
    else:
        return redirect(url_for('login'))


@app.route('/login/', methods=['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        userPassword = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM UserAccounts WHERE username = %s OR email = %s;', (username, username,))
        account = cursor.fetchone()
        if account is not None:
            password = account['password']
            if check_pwd.check_password(userPassword, password):
                session['loggedIn'] = True
                session['user_id'] = account['user_id']
                session['username'] = account['username']
                session['is_staff'] = account['is_staff']
                session['is_superuser'] = account['is_superuser']
                return redirect(url_for('jump'))
            else:
                msg = 'Incorrect password!'
        else:
            msg = 'Incorrect username'
    if 'loggedIn' in session:
        return redirect(url_for('index'))
    else:
        return render_template('login.html', msg=msg)


@app.route('/jump', methods=['GET', 'POST'])
def jump():
    previous_url = str(request.referrer)
    urlList = [x for x in previous_url.split('/') if x != '']
    if urlList[-1] == 'login':
        return render_template('jump.html', goUrl='/dashboard')
    else:
        return render_template('jump.html', goUrl='/login/')


@app.route('/logout')
def logout():
    session.pop('loggedIn', None)
    session.pop('id', None)
    session.pop('username', None)
    session.pop('is_staff', None)
    session.pop('is_superuser', None)
    return redirect(url_for('index'))


@app.route('/register', methods=['GET', 'POST'])
def register():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form:
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        firstName = request.form['first_name']
        lastName = request.form['last_name']
        birthdate = request.form['birthdate']
        address = request.form['address']
        phoneNumber = request.form['phone_number']
        password = check_pwd.set_password(password)
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM UserAccounts WHERE username = %s;', (username,))
        account = cursor.fetchone()
        if account:
            msg = 'Username or Email already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password or not email:
            msg = 'Please fill out the form!'
        else:
            cursor.execute('INSERT INTO UserAccounts (username, email, password) VALUES(%s, %s, %s);', (username, email, password,))
            mysql.connection.commit()
            cursor.execute('SELECT user_id FROM UserAccounts WHERE username = %s;', (username,))
            account = cursor.fetchone()
            cursor.execute(
                'INSERT INTO Customers (user_id, first_name, last_name, birthdate, address, phone_number) VALUES(%s, %s, %s, %s, %s, %s);',
                (account['user_id'], firstName, lastName, birthdate, address, phoneNumber))
            mysql.connection.commit()
            return redirect(url_for('jump'))
    elif request.method == 'POST':
        msg = 'Please fill out the form!'
    return render_template('register.html', msg=msg)


@app.route('/userDetail', methods=['GET', 'POST'])
def user_detail():
    if 'loggedIn' in session:
        userID = session['user_id']
        isStaff = session['is_staff']
        isSuperuser = session['is_superuser']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("""SELECT * FROM UserAccounts AS U 
                            LEFT JOIN Customers AS C ON C.user_id=U.user_id 
                            LEFT JOIN Staff AS S ON S.user_id=U.user_id 
                            WHERE U.user_id=%s;""", (userID,))
        userDetail = cursor.fetchone()
        if request.method == 'GET':
            return render_template('user_detail.html', username=session['username'], user_detail=userDetail, is_staff=isStaff, is_superuser=isSuperuser)
        elif request.method == 'POST' and 'old_password' in request.form and 'new_password' in request.form:
            oldPassword = request.form.get('old_password')
            newPassword = request.form.get('new_password')
            password = userDetail['password']
            if check_pwd.check_password(oldPassword, password):
                newPassword = check_pwd.set_password(newPassword)
                cursor.execute('UPDATE UserAccounts SET password = %s WHERE user_id=%s;', (newPassword, userID,))
                mysql.connection.commit()
                msg = 'Successful!'
            else:
                msg = 'Incorrect password!'
        else:
            username = request.form.get('username')
            email = request.form.get('email')
            firstName = request.form.get('firstName')
            lastName = request.form.get('lastName')
            birthdate = request.form.get('birthdate')
            address = request.form.get('address')
            phoneNumber = request.form.get('phoneNumber')
            is_staff = session['is_staff']
            cursor.execute('UPDATE UserAccounts SET username = %s,  email = %s WHERE user_id=%s;', (username, email, userID,))
            mysql.connection.commit()
            if is_staff == 0:
                cursor.execute(
                    'UPDATE Customers SET first_name = %s,  last_name = %s, birthdate = %s, address = %s, phone_number = %s WHERE user_id=%s;',
                    (firstName, lastName, birthdate, address, phoneNumber, userID,))
                mysql.connection.commit()
            else:
                cursor.execute(
                    'UPDATE Staff SET first_name = %s,  last_name = %s, birthdate = %s, address = %s, phone_number = %s WHERE user_id=%s;',
                    (firstName, lastName, birthdate, address, phoneNumber, userID,))
                mysql.connection.commit()
            msg = 'Successful!'
            cursor.execute("SELECT * FROM UserAccounts AS U LEFT JOIN Customers AS C ON C.user_id=U.user_id WHERE U.user_id=%s;", (userID,))
            userDetail = cursor.fetchone()
        return render_template('user_detail.html', username=session['username'], user_detail=userDetail, msg=msg, is_staff=isStaff, is_superuser=isSuperuser)
    else:
        return redirect(url_for('login'))


car_msg = ""


@app.route('/carList', methods=['GET', 'POST'])
def car_list():
    global car_msg
    msg = car_msg
    car_msg = ""
    if 'loggedIn' in session:
        isStaff = session['is_staff']
        isSuperuser = session['is_superuser']
        if request.method == 'POST':
            carLocation = request.form.get('search-location')
            search = request.form.get('search-value')
            page = None
        else:
            page = request.args.get('page')
            search = request.args.get('search')
            carLocation = request.args.get('location')
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        if page is None:
            sqlPage = 0
        else:
            page = int(page)
            sqlPage = (page - 1) * 10
        if carLocation == 'None':
            carLocation = None
        if search == '':
            search = None
        if search is None:
            if carLocation is None:
                cursor.execute('SELECT count(*) AS count FROM Cars;')
                carCount = cursor.fetchone()
                carCount = math.ceil(carCount['count'] / 10)
                sql = """SELECT * FROM Cars 
                            LEFT JOIN Location ON Location.location_id=Cars.location 
                            LIMIT %s, 10;"""
                value = (sqlPage,)
            else:
                cursor.execute(
                    'SELECT count(*) AS count FROM Cars LEFT JOIN Location ON Location.location_id=Cars.location WHERE location_id = %s;',
                    (carLocation,))
                carCount = cursor.fetchone()
                carCount = math.ceil(carCount['count'] / 10)
                sql = """SELECT * FROM Cars 
                            LEFT JOIN Location ON Location.location_id=Cars.location 
                            WHERE location_id = %s
                            LIMIT %s, 10;"""
                value = (carLocation, sqlPage,)
        else:
            if carLocation is None:
                sqlSearch = "%" + search + "%"
                cursor.execute(
                    'SELECT count(*) AS count FROM Cars LEFT JOIN Location ON Location.location_id=Cars.location WHERE CONCAT(brand, model, year, fuel_type, transmission, vehicle_type, color) LIKE %s;',
                    (sqlSearch,))
                carCount = cursor.fetchone()
                carCount = math.ceil(carCount['count'] / 10)
                sql = """SELECT * FROM Cars 
                            LEFT JOIN Location ON Location.location_id=Cars.location 
                            WHERE CONCAT(brand, model, year, fuel_type, transmission, vehicle_type, color) LIKE %s
                            LIMIT %s, 10;"""

                value = (sqlSearch, sqlPage,)
            else:
                sqlSearch = "%" + search + "%"
                cursor.execute(
                    'SELECT count(*) AS count FROM Cars LEFT JOIN Location ON Location.location_id=Cars.location WHERE CONCAT(brand, model, year, fuel_type, transmission, vehicle_type, color) LIKE %s and location_id = %s;',
                    (sqlSearch, carLocation,))
                carCount = cursor.fetchone()
                carCount = math.ceil(carCount['count'] / 10)
                sql = """SELECT * FROM Cars 
                            LEFT JOIN Location ON Location.location_id=Cars.location 
                            WHERE CONCAT(brand, model, year, fuel_type, transmission, vehicle_type, color) LIKE %s and location_id = %s 
                            LIMIT %s, 10;"""

                value = (sqlSearch, carLocation, sqlPage,)
        cursor.execute(sql, value)
        account = cursor.fetchall()
        if page is None:
            page = 1
        cursor.execute('SELECT * FROM Location;')
        locationList = cursor.fetchall()
        return render_template('car.html', username=session['username'], car_list=account, car_count=carCount, search=search, car_location=carLocation, is_staff=isStaff, is_superuser=isSuperuser, page=page, msg=msg, location_list=locationList)
    else:
        return redirect(url_for('login'))


@app.route('/editCar', methods=['POST'])
def edit_car():
    global car_msg
    if 'loggedIn' in session:
        if session['is_staff'] == 1 or session['is_superuser'] == 1:
            brand_ = request.form.get('brand_')
            model_ = request.form.get('model_')
            year_ = request.form.get('year_')
            fuel_type_ = request.form.get('fuel_type_')
            transmission_ = request.form.get('transmission_')
            seating_capacity_ = request.form.get('seating_capacity_')
            vehicle_type_ = request.form.get('vehicle_type_')
            rental_price_ = request.form.get('rental_price_')
            registration_number_ = request.form.get('registration_number_')
            color_ = request.form.get('color_')
            location_ = request.form.get('location_')
            car_id = request.form.get('car_id')
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            file = request.files['file']
            if file:
                # /home/leozhao95/mysite2/static/image
                filename = str(uuid.uuid4()) + '.jpg'
                file.save(f"./static/image/{filename}")
                fileName = f"../static/image/{filename}"
                if not car_id:
                    cursor.execute("""INSERT INTO Cars (brand, model, year, fuel_type, transmission, seating_capacity, 
                                        vehicle_type, rental_price, registration_number, color, location, image_url) 
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""",
                                   (brand_, model_, year_, fuel_type_, transmission_, seating_capacity_, vehicle_type_, rental_price_, registration_number_, color_, location_, fileName,))
                    mysql.connection.commit()
                else:
                    cursor.execute("""UPDATE Cars SET brand=%s, model=%s, year=%s, fuel_type=%s, transmission=%s, 
                                        seating_capacity=%s, vehicle_type=%s, rental_price=%s, registration_number=%s, color=%s, location=%s, image_url=%s 
                                        WHERE car_id=%s;""",
                                   (brand_, model_, year_, fuel_type_, transmission_, seating_capacity_, vehicle_type_, rental_price_, registration_number_, color_, location_, fileName, car_id,))
                    mysql.connection.commit()
            else:
                car_msg = "No image file can be upload!"
                if not car_id:
                    cursor.execute("""INSERT INTO Cars (brand, model, year, fuel_type, transmission, seating_capacity, 
                                        vehicle_type, rental_price, registration_number, color, location) 
                                        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""",
                                   (brand_, model_, year_, fuel_type_, transmission_, seating_capacity_, vehicle_type_, rental_price_, registration_number_, color_, location_,))
                    mysql.connection.commit()
                else:
                    cursor.execute("""UPDATE Cars SET brand=%s, model=%s, year=%s, fuel_type=%s, transmission=%s, 
                                        seating_capacity=%s, vehicle_type=%s, rental_price=%s, registration_number=%s, color=%s, location=%s 
                                        WHERE car_id=%s;""",
                                   (brand_, model_, year_, fuel_type_, transmission_, seating_capacity_, vehicle_type_, rental_price_, registration_number_, color_, location_, car_id,))
                    mysql.connection.commit()
            return redirect(url_for('car_list'))
        else:
            return redirect(url_for('login'))
    else:
        return redirect(url_for('login'))


@app.route('/deleteCar')
def delete_car():
    if 'loggedIn' in session:
        car_id = request.args.get('car_id')
        if session['is_staff'] == 1 or session['is_superuser'] == 1:
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('DELETE FROM Cars WHERE car_id = %s;', (car_id,))
            mysql.connection.commit()
            print(1)
            return redirect(url_for('car_list'))
        else:
            return redirect(url_for('login'))
    else:
        return redirect(url_for('login'))


@app.route('/userList', methods=['GET', 'POST'])
def user_list():
    if 'loggedIn' in session:
        msg = ''
        isStaff = session['is_staff']
        isSuperuser = session['is_superuser']
        if isStaff == 0 and isSuperuser == 0:
            return redirect(url_for('login'))
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        if request.method == 'POST':
            username = request.form.get('username')
            email = request.form.get('email')
            firstName = request.form.get('firstName')
            lastName = request.form.get('lastName')
            birthdate = request.form.get('birthdate')
            address = request.form.get('address')
            phoneNumber = request.form.get('phone_number')
            userID = request.form.get('userID')
            isStaff_ = request.form.get('isStaff')
            cursor.execute('SELECT * FROM UserAccounts WHERE username = %s;', (username,))
            account = cursor.fetchone()
            if account:
                msg = 'Username or Email already exists!'
            elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
                msg = 'Invalid email address!'
            elif not re.match(r'[A-Za-z0-9]+', username):
                msg = 'Username must contain only characters and numbers!'
            else:
                if not userID:
                    password = request.form.get('password')
                    password = check_pwd.set_password(password)
                    if isStaff_ == '0':
                        cursor.execute('INSERT INTO UserAccounts (username, email, password, is_staff) VALUES(%s, %s, %s, 1);', (username, email, password,))
                        mysql.connection.commit()
                        cursor.execute('SELECT user_id FROM UserAccounts WHERE username = %s;', (username,))
                        account = cursor.fetchone()
                        cursor.execute('INSERT INTO Staff (user_id, first_name, last_name, birthdate, address, phone_number) VALUES(%s, %s, %s, %s, %s, %s);', (account['user_id'], firstName, lastName, birthdate, address, phoneNumber))
                        mysql.connection.commit()
                    else:
                        cursor.execute('INSERT INTO UserAccounts (username, email, password) VALUES(%s, %s, %s);', (username, email, password,))
                        mysql.connection.commit()
                        cursor.execute('SELECT user_id FROM UserAccounts WHERE username = %s;', (username,))
                        account = cursor.fetchone()
                        cursor.execute('INSERT INTO Customers (user_id, first_name, last_name, birthdate, address, phone_number) VALUES(%s, %s, %s, %s, %s, %s);', (account['user_id'], firstName, lastName, birthdate, address, phoneNumber))
                        mysql.connection.commit()
                else:
                    if isStaff_ == '0':
                        cursor.execute('UPDATE UserAccounts SET username = %s, email = %s WHERE user_id = %s;', (username, email, userID,))
                        mysql.connection.commit()
                        cursor.execute('UPDATE Staff SET first_name = %s, last_name = %s, birthdate = %s, address = %s, phone_number = %s WHERE user_id = %s;', (firstName, lastName, birthdate, address, phoneNumber, userID,))
                        mysql.connection.commit()
                    else:
                        cursor.execute('UPDATE UserAccounts SET username = %s, email = %s WHERE user_id = %s;', (username, email, userID,))
                        mysql.connection.commit()
                        cursor.execute('UPDATE Customers SET first_name = %s, last_name = %s, birthdate = %s, address = %s, phone_number = %s WHERE user_id = %s;', (firstName, lastName, birthdate, address, phoneNumber, userID,))
                        mysql.connection.commit()
        staffList = None
        if isSuperuser == 1:
            cursor.execute('SELECT * FROM Staff AS S LEFT JOIN UserAccounts AS U ON S.user_id=U.user_id')
            staffList = cursor.fetchall()
            for i in range(len(staffList)):
                staffList[i]['birthdate'] = str(staffList[i]['birthdate'])
        cursor.execute('SELECT * FROM Customers AS C LEFT JOIN UserAccounts AS U ON C.user_id=U.user_id')
        customersList = cursor.fetchall()
        for i in range(len(customersList)):
            customersList[i]['birthdate'] = str(customersList[i]['birthdate'])
        return render_template('user_edit.html', username=session['username'], staff_list=staffList, customers_list=customersList, is_staff=isStaff, is_superuser=isSuperuser, msg=msg)
    else:
        return redirect(url_for('login'))


@app.route('/deleteUser')
def delete_user():
    if 'loggedIn' in session:
        isStaff = request.args.get('isStaff')
        userID = request.args.get('userID')
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        if isStaff == '0':
            if session['is_superuser'] == 1:
                cursor.execute('DELETE FROM Staff WHERE user_id = %s;', (userID,))
                mysql.connection.commit()
                cursor.execute('DELETE FROM UserAccounts WHERE user_id = %s;', (userID,))
                mysql.connection.commit()
        elif isStaff == '1':
            if session['is_staff'] == 1 or session['is_superuser'] == 1:
                cursor.execute('DELETE FROM Customers WHERE user_id = %s;', (userID,))
                mysql.connection.commit()
                cursor.execute('DELETE FROM UserAccounts WHERE user_id = %s;', (userID,))
                mysql.connection.commit()
        return redirect(url_for('user_list'))
    else:
        return redirect(url_for('login'))


@app.route('/dashboard')
def dashboard():
    if 'loggedIn' in session:
        isStaff = session['is_staff']
        isSuperuser = session['is_superuser']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT Count(*) AS Count FROM Staff;')
        staffCount = cursor.fetchone()
        cursor.execute('SELECT Count(*) AS Count FROM Cars;')
        carsCount = cursor.fetchone()
        cursor.execute('SELECT Count(*) AS Count FROM Customers;')
        customersCount = cursor.fetchone()
        if session['is_staff'] == 1:
            return render_template("staff_dashboard.html", username=session['username'], is_staff=isStaff, is_superuser=isSuperuser, cars_count=carsCount, customers_count=customersCount)
        elif session['is_superuser'] == 1:
            return render_template("admin_dashboard.html", username=session['username'], is_staff=isStaff, is_superuser=isSuperuser, staff_count=staffCount, cars_count=carsCount, customers_count=customersCount)
        else:
            return redirect(url_for('index'))
    else:
        return redirect(url_for('login'))


if __name__ == '__main__':
    app.run()
