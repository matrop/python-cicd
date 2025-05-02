import pytest

from typing import List

from src.api import get_new_id, get_task_by_id, get_tasks_by_tag
from src.classes import Task


def test_get_new_id():
    # test when task_list is empty
    empty_list = []
    assert get_new_id(empty_list) == 0

    # test when task_list is not empty
    task_list: List[Task] = [Task(id=0, name="Test Task 0")]
    assert get_new_id(task_list) == 1


def test_get_task_by_id():
    # test when task_list is empty
    empty_list = []
    with pytest.raises(ValueError):
        get_task_by_id(empty_list, 0)

    # test when task_list is not empty
    task_list: List[Task] = [
        Task(id=0, name="Test Task 0"),
        Task(id=1, name="Test Task 1"),
    ]
    assert get_task_by_id(task_list, 1) == task_list[1]

    with pytest.raises(ValueError):
        get_task_by_id(task_list, 2)


def test_get_tasks_by_tag():
    empty_list = []
    assert get_tasks_by_tag(empty_list, "a") == []

    # test when task_list is not empty
    task_list: List[Task] = [
        Task(id=0, name="Test Task 0", tags=["a"]),
        Task(id=1, name="Test Task 1", tags=["a", "b"]),
    ]

    assert get_tasks_by_tag(task_list, "a") == task_list
    assert get_tasks_by_tag(task_list, "b") == [
        Task(id=1, name="Test Task 1", tags=["a", "b"]),
    ]
