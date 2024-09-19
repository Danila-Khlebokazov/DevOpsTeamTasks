import curses
from collections import namedtuple
import subprocess

PROGRAM_NAME = "USER MANAGER INTERFACE"
VERSION = "0.2.0"
AUTHORS = "D_K"

RUNNING_TITLE = f"{PROGRAM_NAME} v.{VERSION} // {AUTHORS}"

User = namedtuple("User", ["username", "uid", "full_name", "is_locked"])


class ProgramCodes:
    UP = 3
    DOWN = 4
    ADD_USER = 7
    DELETE_USER = 8
    LOCK_USER = 9
    UNLOCK_USER = 10
    EXIT = 11


def get_all_users():
    users = []
    result = subprocess.run(['cat', '/etc/passwd'], stdout=subprocess.PIPE)
    for line in list(filter(lambda x: ":" in x, result.stdout.decode().splitlines())):
        parts = line.split(':')
        print(parts)
        if int(parts[2]) >= 1000:
            username = parts[0]
            uid = parts[2]
            full_name = parts[4]
            is_locked = check_user_locked(username)
            users.append(User(username=username, uid=uid, full_name=full_name, is_locked=is_locked))
    return users


def check_user_locked(username):
    result = subprocess.run(['passwd', '--status', username], stdout=subprocess.PIPE)
    return 'L' in result.stdout.decode()


def add_user(username, full_name):
    subprocess.run(['sudo', 'useradd', '-c', full_name, username])
    subprocess.run(['sudo', 'passwd', username])

def confirm_action(stdscr, message) -> bool:
    curses.echo()
    stdscr.addstr(0, 0, message + " (y/n): ")
    stdscr.refresh()
    response = stdscr.getstr().decode("utf-8").lower()
    curses.noecho()
    return response == "y"

def delete_user(username, stdscr):
    stdscr.clear()
    message = f"Are you sure that you want to delete this user? '{username}' ?"

    if confirm_action(stdscr, message):
        subprocess.run(['sudo', 'userdel', '-r', username], stderr=subprocess.DEVNULL)
        stdscr.addstr(1, 0, f"User with '{username}' has been successfully deleted, press any key to continue")
    else:
        stdscr.addstr(1, 0, f"User deletion cancelled, press any key to continue")
    
    stdscr.refresh()
    stdscr.getch()


def lock_user(username):
    subprocess.run(['sudo', 'passwd', '-l', username])


def unlock_user(username):
    subprocess.run(['sudo', 'passwd', '-u', username])


def input_text(stdscr, prompt):
    curses.echo()
    stdscr.addstr(prompt)
    stdscr.refresh()
    input_str = stdscr.getstr().decode("utf-8")
    curses.noecho()
    return input_str


def show_user_table(stdscr, users, current_selection):
    stdscr.clear()

    table = [
        ["No.", "Username", "UID", "Full Name", "Locked"],
        *[[str(idx + 1), user.username, user.uid, user.full_name, "Locked" if user.is_locked else "Unlocked"] for
          idx, user in enumerate(users)]
    ]

    for i, (idx, username, uid, f_n, locked) in enumerate(table):
        stdscr.addstr(i, 0, f"{idx:2} {username:10} {uid:5} {f_n:20} {locked}")

    for idx, user in enumerate(users):
        locked_status = "Locked" if user.is_locked else "Unlocked"
        line = f"{idx + 1}. {user.username:10} {user.uid:5} {user.full_name:20} {locked_status}"

        if idx == current_selection:
            stdscr.addstr(idx + 1, 0, line, curses.A_REVERSE)
        else:
            stdscr.addstr(idx + 1, 0, line)

    stdscr.refresh()


def key_catcher(stdscr):
    key = stdscr.getch()
    if key == curses.KEY_UP:
        return ProgramCodes.UP
    elif key == curses.KEY_DOWN:
        return ProgramCodes.DOWN
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
    commands = "[Q] Exit | [N] Add User | [D] Delete User | [L] Lock User | [U] Unlock User"
    stdscr.addstr(height - 1, 0, commands, curses.A_BOLD)


def main(stdscr):
    curses.start_color()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.curs_set(0)

    users = get_all_users()
    current_option = 0
    while True:
        height, width = stdscr.getmaxyx()

        show_user_table(stdscr, users, current_option)
        show_commands(stdscr, height)

        key = key_catcher(stdscr)
        if key == ProgramCodes.EXIT:
            break
        elif key == ProgramCodes.ADD_USER:
            username = input_text(stdscr, "Enter username: ")
            full_name = input_text(stdscr, "Enter full name: ")
            add_user(username, full_name)
            users = get_all_users()
        elif key == ProgramCodes.DELETE_USER:
            delete_user(users[current_option].username, stdscr)
            users = get_all_users()
            current_option = min(current_option, len(users) - 1)
        elif key == ProgramCodes.LOCK_USER:
            lock_user(users[current_option].username)
            users = get_all_users()
        elif key == ProgramCodes.UNLOCK_USER:
            unlock_user(users[current_option].username)
            users = get_all_users()
        elif key == ProgramCodes.UP and current_option > 0:
            current_option -= 1
        elif key == ProgramCodes.DOWN and current_option < len(users) - 1:
            current_option += 1


if __name__ == "__main__":
    curses.wrapper(main)
    subprocess.run("clear", subprocess.PIPE)
