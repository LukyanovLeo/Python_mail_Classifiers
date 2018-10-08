import email            # for retrieving mail info
import os               # for dirs creation
import re             # for search by x-mailer name
from shutil import move # for moving mail to specified dir

# search only eml files
list_of_files = filter(lambda x: x.endswith('.eml'), os.listdir("new_mimes2"))

# get mail info
for file in list_of_files:
    str = "new_mimes2/" + file
    mail = open(str)
    msg = email.message_from_file(mail)
    if msg['message-id'] != None:
        # numbers and '$' and '-'
        if re.search(r'<[0-9-$]+@.+>', msg['message-id']):
            if not os.path.exists("new_mimes2/numbers"):
                print("Creating directory 'numbers'...")
                os.makedirs("new_mimes2/numbers")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/numbers")

        # capital letters and '$' and '-'
        elif re.search(r'<[A-Z-$]+@.+>', msg['message-id']):
            if not os.path.exists("new_mimes2/capital_letters"):
                print("Creating directory 'capital_letters'...")
                os.makedirs("new_mimes2/capital_letters")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/capital_letters")

        # lowercase letters and '$' and '-'
        elif re.search(r'<[a-z-$]+@.+>', msg['message-id']):
            if not os.path.exists("new_mimes2/lowercase_letters"):
                print("Creating directory 'lowercase_letters'...")
                os.makedirs("new_mimes2/lowercase_letters")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/lowercase_letters")

        # at least 1 capital letter and 1 number
        elif re.search(r'<(?=.*\d)(?![.\n])(?=.*[A-Z]).*@.+>', msg['message-id']):
            if not os.path.exists("new_mimes2/capital_letters_and_numbers"):
                print("Creating directory 'capital_letters_and_numbers'...")
                os.makedirs("new_mimes2/capital_letters_and_numbers")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/capital_letters_and_numbers")

        # at least 1 lowercase letter and 1 number
        elif re.search(r'<(?=.*\d)(?![.\n])(?=.*[a-z-]).*@.+>', msg['message-id']):
            if not os.path.exists("new_mimes2/lowercase_letters_and_numbers"):
                print("Creating directory 'lowercase_letters_and_numbers'...")
                os.makedirs("new_mimes2/lowercase_letters_and_numbers")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/lowercase_letters_and_numbers")
        # else move mail to dir 'other'
        else:
            if not os.path.exists("new_mimes2/other"):
                print("Creating directory 'other'...")
                os.makedirs("new_mimes2/other")
            mail.close()  # close mail to move it
            move(str, "new_mimes2/other")

    # if message-id is None move mail to dir 'other' too
    else:
        if not os.path.exists("new_mimes2/other"):
            print("Creating directory 'other'...")
            os.makedirs("new_mimes2/other")
        mail.close()  # close mail to move it
        move(str, "new_mimes2/other")
