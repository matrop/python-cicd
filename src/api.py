import logging

from typing import List, Optional
from fastapi import FastAPI, HTTPException

from .classes import Task

app = FastAPI()

task_list: List[Task] = []


def get_new_id(task_list: List[Task]):
    if not task_list:
        return 0

    return task_list[-1].id + 1


def get_task_by_id(task_list: List[Task], id: int) -> Task:
    for task in task_list:
        if id == task.id:
            return task

    raise ValueError(f"Could not find task with id '{id}'")


def get_tasks_by_tag(task_list: List[Task], tag: str) -> List[Task]:
    return [task for task in task_list if tag in task.tags]


@app.post("/tasks")
def create_task(
    name: str, description: Optional[str] = None, tags: List[str] = []
):
    id = get_new_id(task_list)

    new_task = Task(id=id, name=name, description=description, tags=tags)
    task_list.append(new_task)

    return new_task.model_dump()


@app.delete("/tasks/{id}")
def delete_task(id: int):
    try:
        task = get_task_by_id(task_list, id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))

    task_list.remove(task)

    return {"result": f"task id '{id}' deleted"}


@app.get("/tasks")
def list_tasks(tag: Optional[str] = None):
    if tag:
        return {"tasks": [task.dict() for task in get_tasks_by_tag(task_list, tag)]}
    return {"tasks": [task.dict() for task in task_list]}
