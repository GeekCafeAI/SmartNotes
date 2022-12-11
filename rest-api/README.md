### Start server instructions

1. Create an environment with either **conda** or **venv**
2. Activate the environment
3. `pip install -r requirements.txt`
4. Now you have to run server and worker that does processing in separate terminals
    1. `cd rest-api && dramatiq src.mock_worker --threads 1 --processes 1`
    2. `flask --app rest-api/src/server run`
