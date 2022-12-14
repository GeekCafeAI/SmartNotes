## Start server instructions

1. Create an environment with either **conda** or **venv**
2. Activate the environment
3. `pip install -r requirements.txt`
4. Now you have to run server ~~and worker that does processing in separate terminals~~
    1. ~~`cd rest-api && dramatiq src.mock_worker --threads 1 --processes 1`~~
    2. `flask --app rest-api/src/server run`
## Endpoints

### Note entity

```
    id: int
    user_id: str
    status: str
    text: str
    tags: comma-separated str
    extracted_date: datetime
    created_at: datetime
    updated_at: datetime
```

### POST "/notes"
Creates new note.

Content type: application/json.

Payload parameters: `{"text":<Text of the note>,"user_id":<String that identifies the user>}`

Response JSON: `{"message":<str>,"note":<note entity>}`

### PUT "/notes"

Edit note by its id.

Content type: application/json.

Payload parameters: `{"id":<id of the note>,"user_id":<String that identifies the user>,"text","tags","extracted_date"}`

Response JSON: `{"message":<str>,"note":<edited note entity>}`

### GET "/notes?id=`<int>`&user_id=`<str>`"
Returns one note by id or, if id is empty, returns all notes.

Content type: plain

Payload parameters: `{"id":<id of the note>,"user_id":<String that identifies the user>}`

Response JSON: `{"message":<str>,"note":<note entity>}` (If id is found)

Response JSON: `{"message":<str>,"notes":[<note entity1>,<note entity2>,...]}` (If id is not found)
