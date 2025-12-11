# syntax=docker/dockerfile:1

# Define a default value for the argument PY_VER
ARG PY_VER=3.12

# slim version of Python 3.## to minimize the size of the container and make it as lightweight as possible
FROM python:${PY_VER}-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Optimize pip
ENV PIP_DEFAULT_TIMEOUT=100 \
    # Allow statements and log messages to immediately appear
    PYTHONUNBUFFERED=1 \
    # disable a pip version check to reduce run-time & log-spam
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    # cache is useless in docker image, so disable to reduce image size
    PIP_NO_CACHE_DIR=1

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# Expose port 8080 for both Flask and Gunicorn server
EXPOSE 8080


# CMD uses the JSON array format ["command", "arg1", "arg2", ...]

# Quick debugging test
#CMD ["echo", "test"]


# If app is FastAPI, use Uvicorn. It’s faster, lighter, and Cloud Run handles scaling.
# If app is (Flask, Django WSGI): Use Gunicorn (pure WSGI).


# For Gunicorn:
# Use ENTRYPOINT to definitively launch Gunicorn with Uvicorn workers.
# This ensures the command is executed as the primary process.
# Cloud Run expects your application to listen on the port specified by the PORT environment variable (default 8080).
# Use 0.0.0.0 to bind to all available network interfaces.
# --workers can be adjusted based on Cloud Run's CPU allocation (e.g., 2 * CPU_CORES + 1).
#ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8080", "--worker-class", "uvicorn.workers.UvicornWorker", "--workers", "1", "api_mcp_fastapi_server:app"]


# Revise the 2nd argument to specify the script filename without the .py extension, and the FastAPI object (typically "app").
#CMD ["uvicorn", "api_mcp_fastapi_server:app", "--host", "0.0.0.0", "--port", "8080"]
# IMPORTANT:  When a container runs on Google Cloud Run, it automatically sets an environment variable, $PORT$, 
# to the port number that the container must listen on (usually $8080$). 
# The container must read this variable and bind its server to the port it specifies.
# Cloud run automatically provides an environment variable ${PORT}, but that the shell form can accept, but the exec (json array) form cannot.
# Change the CMD instruction to the shell form: CMD uvicorn api_mcp_fastapi_server:app --host 0.0.0.0 --port $PORT.
CMD uvicorn api_mcp_fastapi_server:app --host 0.0.0.0 --port $PORT

# Below is the exec (json array) form:
#CMD ["uvicorn", "api_mcp_fastapi_server:app", "--host", "0.0.0.0", "--port", "8080"]


