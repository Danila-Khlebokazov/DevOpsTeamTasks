import curses
import subprocess
from collections import namedtuple

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
    subprocess.run(['sudo', 'useradd', '-m', '-c', full_name, username])
    subprocess.run(['sudo', 'chpasswd'], input=f'{username}:{password}', text=True)


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
        subprocess.run(['sudo', 'userdel', '-r', '-f', username], stderr=subprocess.DEVNULL)
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
        subprocess.run(['sudo', 'passwd', '-l', username], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        stdscr.addstr(1, 0, f"User with '{username}' has been successfully locked, press any key to continue")
    else:
        stdscr.addstr(1, 0, f"User locking cancelled, press any key to continue")

    stdscr.refresh()
    stdscr.getch()


def unlock_user(username):
    subprocess.run(['sudo', 'passwd', '-u', username])


def input_text(stdscr, prompt, height, width):
    curses.echo()
    stdscr.addstr(height - 2, 0, prompt)
    stdscr.refresh()
    input_str = stdscr.getstr().decode("utf-8")
    curses.noecho()
    stdscr.addstr(height - 2, 0, " " * width)
    return input_str


def show_user_table(stdscr, users, current_selection, current_page, total_pages, page_size):
    stdscr.clear()
    height, width = stdscr.getmaxyx()
    start = (current_page - 1) * page_size
    page_users = users[start:start + page_size]

    table = [
        ["No.", "Username", "UID", "Full Name", "Locked"],
        *[[str(idx + start + 1), user.username, user.uid, user.full_name, "Locked" if user.is_locked else "Unlocked"]
          for
          idx, user in enumerate(page_users)]
    ]
    max_size_columns = [max(len(str(row[i])) for row in table) for i in range(len(table[0]))]

    for i, (idx, username, uid, full_name, locked) in enumerate(table):
        line = "| "
        for j, col in enumerate([idx, username, uid, full_name, locked]):
            line += col.ljust(max_size_columns[j] + 2) + " |"

        if i == 0:
            stdscr.addstr(i + 1, 0, line, curses.A_BOLD)
            continue

        if i == current_selection + 1:
            stdscr.addstr(i + 1, 0, line, curses.A_REVERSE)
        else:
            stdscr.addstr(i + 1, 0, line)

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
    elif key == curses.KEY_BACKSPACE:
        return ProgramCodes.DELETE_USER
    elif key == ord("q") or key == ord("Q"):
        return ProgramCodes.EXIT
    elif key == ord("n") or key == ord("N"):
        return ProgramCodes.ADD_USER
    elif key == ord("l") or key == ord("L"):
        return ProgramCodes.LOCK_USER
    elif key == ord("u") or key == ord("U"):
        return ProgramCodes.UNLOCK_USER
    else:
        return 0


def show_commands(stdscr, height):
    commands = "[←/→] Prev/Next Page | [↑/↓] Navigate | [N] Add User | [BACKSPACE] Delete User | [L] Lock | [U] Unlock | [Q] Quit"
    stdscr.addstr(height - 1, 0, commands[:stdscr.getmaxyx()[1] - 1], curses.A_BOLD)


def update_table(stdscr, users):
    page_size = stdscr.getmaxyx()[0] - 4
    return page_size, math.ceil(len(users) / page_size)


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
        elif key == ProgramCodes.ADD_USER:
            username = input_text(stdscr, "Enter username: ", height, width)
            if " " in username:
                stdscr.addstr(height - 2, 0, "Username cannot contain spaces, press any key to continue")
                stdscr.getch()
                continue
            if username in [user.username for user in users]:
                stdscr.addstr(height - 2, 0, "Username already exists, press any key to continue")
                stdscr.getch()
                continue

            full_name = input_text(stdscr, "Enter full name: ", height, width)
            passwrd = input_text(stdscr, "Enter new password: ", height, width)
            passwrd_2 = input_text(stdscr, "Enter new password (again): ", height, width)
            if passwrd != passwrd_2:
                stdscr.addstr(height - 2, 0, "Passwords do not match, press any key to continue")
                stdscr.getch()
                continue
            add_user(username, full_name, passwrd)
            users = get_all_users()
            page_size, total_pages = update_table(stdscr, users)
        elif key == ProgramCodes.DELETE_USER:
            delete_user(users[(current_page - 1) * page_size + current_option].username, stdscr)
            users = get_all_users()
            current_option = min(current_option, len(users) - 1)
            page_size, total_pages = update_table(stdscr, users)
            if current_page > total_pages:
                current_page -= 1
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
