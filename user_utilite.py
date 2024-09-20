import curses
from collections import namedtuple
import subprocess
import math

PROGRAM_NAME = "USER MANAGER INTERFACE"
VERSION = "0.2.0"
AUTHORS = "D_K"

CURRENT_USER_NAME = None

RUNNING_TITLE = f"{PROGRAM_NAME} v.{VERSION} // {AUTHORS}"

User = namedtuple("User", ["username", "uid", "full_name", "is_locked"])


class ProgramCodes:
    UP = 3
    DOWN = 4
    LEFT = 5
    RIGHT = 6
    ADD_USER = 7
    DELETE_USER = 8
    LOCK_USER = 9
    UNLOCK_USER = 10
    EXIT = 11


def get_all_users():
    users = []
    result = subprocess.run(['sudo', 'cat', '/etc/passwd'], stdout=subprocess.PIPE)
    for line in list(filter(lambda x: ":" in x, result.stdout.decode().splitlines())):
        parts = line.split(':')
        if int(parts[2]) >= 1000 and parts[0] != "nobody":
            username = parts[0]
            uid = parts[2]
            full_name = parts[4]
            is_locked = check_user_locked(username)
            users.append(User(username=username, uid=uid, full_name=full_name, is_locked=is_locked))
    return users


def check_user_locked(username):
    result = subprocess.run(['sudo', 'passwd', '--status', username], stdout=subprocess.PIPE)
    return 'L' in result.stdout.decode()


def add_user(username, full_name, password):
    subprocess.run(['sudo', 'useradd', '-c', full_name, "-p", password, username])


def confirm_action(stdscr, message) -> bool:
    curses.echo()
    stdscr.addstr(0, 0, message + " (y/n): ")
    stdscr.refresh()
    response = stdscr.getstr().decode("utf-8").lower()
    curses.noecho()
    return response == "y"


def delete_user(username, stdscr):
    stdscr.clear()
    if username == CURRENT_USER_NAME:
        stdscr.addstr(0, 0, "You cannot delete yourself, press any key to continue")
        stdscr.refresh()
        stdscr.getch()
        return
    message = f"Are you sure that you want to delete this user? '{username}' ?"

    if confirm_action(stdscr, message):
        subprocess.run(['sudo', 'userdel', '-r', username], stderr=subprocess.DEVNULL)
        stdscr.addstr(1, 0, f"User with '{username}' has been successfully deleted, press any key to continue")
    else:
        stdscr.addstr(1, 0, f"User deletion cancelled, press any key to continue")

    stdscr.refresh()
    stdscr.getch()


def lock_user(stdscr, username):
    stdscr.clear()
    if username == CURRENT_USER_NAME:
        stdscr.addstr(0, 0, "You cannot lock yourself, press any key to continue")
        stdscr.refresh()
        stdscr.getch()
        return

    message = f"Are you sure that you want to LOCK this user? '{username}' ?"

    if confirm_action(stdscr, message):
        subprocess.run(['sudo', 'passwd', '-l', username])
        stdscr.addstr(1, 0, f"User with '{username}' has been successfully locked, press any key to continue")
    else:
        stdscr.addstr(1, 0, f"User locking cancelled, press any key to continue")

    stdscr.refresh()


def unlock_user(username):
    subprocess.run(['sudo', 'passwd', '-u', username])


def input_text(stdscr, prompt, height):
    curses.echo()
    stdscr.addstr(height - 2, 0, prompt)
    stdscr.refresh()
    input_str = stdscr.getstr().decode("utf-8")
    curses.noecho()
    return input_str

# TODO id on the next pages should be fixed
def show_user_table(stdscr, users, current_selection, current_page, total_pages, page_size):
    stdscr.clear()
    height, width = stdscr.getmaxyx()
    start = (current_page - 1) * page_size
    page_users = users[start:start + page_size]
    

    table = [
        ["No.", "Username", "UID", "Full Name", "Locked"],
        *[[str(idx + start + 1), user.username, user.uid, user.full_name, "Locked" if user.is_locked else "Unlocked"] for
          idx, user in enumerate(page_users)]
    ]

    for i, (idx, username, uid, f_n, locked) in enumerate(table):
        stdscr.addstr(i, 0, f"{idx:2} {username:10} {uid:5} {f_n:20} {locked}")

    for idx, user in enumerate(page_users):
        locked_status = "Locked" if user.is_locked else "Unlocked"
        line = f"{idx + 1}. {user.username:10} {user.uid:5} {user.full_name:20} {locked_status}"

        if idx == current_selection:
            stdscr.addstr(idx + 1, 0, line, curses.A_REVERSE)
        else:
            stdscr.addstr(idx + 1, 0, line)

    page_number = f"Page {current_page}/{total_pages}"
    stdscr.addstr(height - 3, (width - len(page_number)) // 2, page_number)

    stdscr.refresh()


def key_catcher(stdscr):
    key = stdscr.getch()
    if key == curses.KEY_UP:
        return ProgramCodes.UP
    elif key == curses.KEY_DOWN:
        return ProgramCodes.DOWN
    elif key == curses.KEY_LEFT:
        return ProgramCodes.LEFT
    elif key == curses.KEY_RIGHT:
        return ProgramCodes.RIGHT
    elif key == ord("q") or key == ord("Q"):
        return ProgramCodes.EXIT
    elif key == ord("n") or key == ord("N"):
        return ProgramCodes.ADD_USER
    elif key == ord("d") or key == ord("D"):
        return ProgramCodes.DELETE_USER
    elif key == ord("l") or key == ord("L"):
        return ProgramCodes.LOCK_USER
    elif key == ord("u") or key == ord("U"):
        return ProgramCodes.UNLOCK_USER
    else:
        return 0


def show_commands(stdscr, height):
    commands = "[LEFT] Prev Page | [RIGHT] Next Page | [UP/DOWN] Navigate | [N] Add User | [Backspace] Delete User | [L] Lock | [U] Unlock | [Q] Quit"
    stdscr.addstr(height - 1, 0, commands[:stdscr.getmaxyx()[1]-1], curses.A_BOLD)


def main(stdscr):
    curses.start_color()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.curs_set(0)

    users = get_all_users()
    current_option = 0
    current_page = 1
    page_size = stdscr.getmaxyx()[0] - 4
    total_pages = math.ceil(len(users) / page_size)
    while True:
        height, width = stdscr.getmaxyx()

        show_user_table(stdscr, users, current_option, current_page, total_pages, page_size)
        show_commands(stdscr, height)

        key = key_catcher(stdscr)
        if key == ProgramCodes.EXIT:
            break
        # FIXME ui bug
        elif key == ProgramCodes.ADD_USER:
            username = input_text(stdscr, "Enter username: ", height)
            full_name = input_text(stdscr, "Enter full name: ", height)
            passwrd = input_text(stdscr, "Enter new password: ", height)
            passwrd_2 = input_text(stdscr, "Enter new password (again): ", height)
            if passwrd != passwrd_2:
                stdscr.addstr(height - 3, 0, "Passwords do not match, press any key to continue")
                stdscr.refresh()
                continue
            add_user(username, full_name, passwrd)
            users = get_all_users()
        elif key == ProgramCodes.DELETE_USER:
            delete_user(users[(current_page - 1) * page_size + current_option].username, stdscr)
            users = get_all_users()
            current_option = min(current_option, len(users) - 1)
        elif key == ProgramCodes.LOCK_USER:
            lock_user(stdscr, users[current_option].username)
            users = get_all_users()
        elif key == ProgramCodes.UNLOCK_USER:
            unlock_user(users[current_option].username)
            users = get_all_users()
        elif key == ProgramCodes.UP:
            if current_option > 0:
                current_option -= 1
            else:
                if current_page > 1:
                    current_page -= 1
                    current_option = page_size - 1
        elif key == ProgramCodes.DOWN and current_option < len(users) - 1:
            if current_option < min(page_size - 1, len(users) - (current_page - 1) * page_size - 1):           
                current_option += 1
            else:
                if current_page < total_pages:
                    current_option = 0
                    current_page += 1
        elif key == ProgramCodes.LEFT and current_page > 1:
            current_page -= 1
            current_option = 0
        elif key == ProgramCodes.RIGHT and current_page < total_pages:
            current_page += 1
            current_option = 0 


if __name__ == "__main__":
    CURRENT_USER_NAME = subprocess.run("whoami", stdout=subprocess.PIPE).stdout.decode().strip()
    subprocess.run("sudo -l", stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    curses.wrapper(main)
    subprocess.run("clear", subprocess.PIPE)
