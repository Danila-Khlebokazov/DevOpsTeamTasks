import curses
import time
import os

PROGRAM_NAME = "USER MANAGER INTERFACE"
VERSION = "0.1.0"
AUTHORS = "Khlebokazov Danila"  # if you participate please add your name here

RUNNING_TITLE = f"{PROGRAM_NAME} v.{VERSION} // {AUTHORS}"

WELCOME_TEXT = "Добро пожаловать в программу!"
PRESS_ENTER_TEXT = "Нажмите Enter для продолжения..."
GOODBYE_TEXT = "До свидания! Спасибо за использование программы."

MENU_DOWN_SHIFT = 1


def check_is_superuser():
    return os.getuid() == 0


class StateManager:
    def __init__(self):
        self.__program_state = "hello"
        self.state_list = ["main", "exit", "add_user", "show_all_users"]

    def change_state(self, state):
        if state in self.state_list:
            self.__program_state = state
        else:
            raise ValueError("Invalid state")

    def get_state(self):
        return self.__program_state


class TerminalScreen:
    def __init__(self, stdscr, screen_title: str = None):
        self.__stdscr = stdscr
        self.__screen_title = screen_title

    def _show_screen_title(self):
        height, width = self.__stdscr.getmaxyx()
        self.__stdscr.attron(curses.color_pair(1))
        self.__stdscr.addstr(height // 2 - 1, (width - len(WELCOME_TEXT)) // 2, WELCOME_TEXT, curses.A_BOLD)
        self.__stdscr.addstr(height // 2 + 1, (width - len(PRESS_ENTER_TEXT)) // 2, PRESS_ENTER_TEXT, curses.A_NORMAL)
        self.__stdscr.attroff(curses.color_pair(1))

    def show(self, *args, **kwargs):
        raise NotImplementedError("Method show() must be implemented in child class")




def read_and_parse(filename):
    """
        Reads and parses lines from /etc/passwd and /etc/group.

        Parameters

          filename : str
            Full path for filename.
    """
    data = []
    with open(filename, "r") as f:
        for line in f.readlines():
            data.append(line.split(":")[0])
        data.sort()
        for item in data:
            print("- " + item)


def get_all_users():
    # read_and_parse("/etc/passwd")
    # read_and_parse("/etc/group")
    tmp_user_list = [{
        "username": "root",
        "uid": 0,
        "full_name": "root",
        "is_locked": True
    }]
    user_list = tmp_user_list
    return user_list


# def show_user_table(stdscr, users):
#     user_options


def state_manager():
    program_state = "hello"
    state_list = ["main", "exit", "add_user", "show_all_users"]

    def change_state(state):
        nonlocal program_state
        if state in state_list:
            program_state = state
        else:
            raise ValueError("Invalid state")

    def get_state():
        return program_state

    return get_state, change_state


state_getter, state_setter = state_manager()


def show_welcome_screen(stdscr, state):
    height, width = stdscr.getmaxyx()
    stdscr.attron(curses.color_pair(1))
    stdscr.addstr(height // 2 - 1, (width - len(WELCOME_TEXT)) // 2, WELCOME_TEXT, curses.A_BOLD)
    stdscr.addstr(height // 2 + 1, (width - len(PRESS_ENTER_TEXT)) // 2, PRESS_ENTER_TEXT, curses.A_NORMAL)
    stdscr.attroff(curses.color_pair(1))
    stdscr.refresh()
    while True:
        key = stdscr.getch()
        if key == 10:
            state_setter(state)
            break


def show_menu(stdscr, options, **kwargs):
    current_option = 0
    max_option_length = max(len(option[0]) for option in options)

    if kwargs.get("extra_padding"):
        ext_padding = kwargs.get("extra_padding")
    else:
        ext_padding = 0

    while True:
        for i, (option, _) in enumerate(options):
            padding = " " * ((max_option_length - len(option)) + 2)
            if i == current_option:
                stdscr.addstr(
                    i + MENU_DOWN_SHIFT + ext_padding,
                    0,
                    f"> {option}{padding}",
                    curses.color_pair(1) | curses.A_REVERSE,
                )
            else:
                stdscr.addstr(i + MENU_DOWN_SHIFT + ext_padding, 0, f"  {option}{padding}", curses.color_pair(1))

        stdscr.refresh()

        key = stdscr.getch()
        if key == curses.KEY_UP and current_option > 0:
            current_option -= 1
        elif key == curses.KEY_DOWN and current_option < len(options) - 1:
            current_option += 1
        elif key == 10:
            state_setter(options[current_option][1])
            break


OPTIONS = {
    "hello": [show_welcome_screen, "main"],
    "main": [show_menu, [("Добавить пользователя", "add_user"), ("Просмотреть всех", "show_all_users"),
                         ("Выйти из программы", "exit")]],
    "add_user": [lambda _, state: state_setter(state), "exit"],
    # "show_all_users": [show_user_table, get_all_users()]
}


def show_canvas(stdout, extension, *args, **kwargs):
    stdout.clear()
    height, width = stdout.getmaxyx()
    stdout.addstr(0, width - len(RUNNING_TITLE) - 2, RUNNING_TITLE, curses.A_BOLD | curses.color_pair(1))
    extension(stdout, *args, **kwargs)


def main(stdout):
    curses.start_color()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    height, width = stdout.getmaxyx()
    curses.curs_set(0)
    curses.resizeterm(20, width)

    while True:
        if state_getter() == "exit":
            break

        show_canvas(stdout, *OPTIONS[state_getter()])


if __name__ == "__main__":
    curses.wrapper(main)
