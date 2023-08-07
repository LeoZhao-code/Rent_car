import bcrypt


def set_password(pwd):
    """
    Encrypt user password.

    Args:
        pwd (str): user password.

    :return: Encrypt user password
    """
    return bcrypt.hashpw(pwd.encode('utf-8'), bcrypt.gensalt())


def check_password(user_pwd, data_pwd):
    """
    Match user password and database password.

    Args:
        user_pwd (str): user password.
        data_pwd (str): user database password.

    :return: Password match
    """
    return bcrypt.checkpw(user_pwd.encode('utf-8'), data_pwd.encode('utf-8'))


