from pydantic import BaseModel
from typing import Optional, List

class Task(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    tags: List[str] = []