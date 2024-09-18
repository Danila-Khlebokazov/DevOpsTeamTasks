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
CONGRATS_TEXT = "Процесс завершился!"
ENCODE_PROCESS_TEXT = "Процесс шифрования..."
DECODE_PROCESS_TEXT = "Процесс расшифрования..."

MENU_DOWN_SHIFT = 1


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
    "show_all_users": [lambda _, state: state_setter(state), "exit"]
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
