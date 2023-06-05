# dev-base
from debian:sid as dev-base
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm git neovim ripgrep tmux python3-pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN pip3 install isort pylint black pyright --user --break-system-packages

WORKDIR /root
RUN git clone https://github.com/bojiang/.dotfile
RUN /root/.dotfile/init.sh

# dev
from dev-base as dev
COPY requirements.txt .
RUN pip3 install -r requirements.txt --user --break-system-packages
COPY requirements-dev.txt .
RUN pip3 install -r requirements-dev.txt --user --break-system-packages
WORKDIR /root/project
CMD ["nvim"]

# prod-base
from debian:bullseye as prod-base
RUN apt-get update && apt-get install -y --no-install-recommends python3-pip 
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

COPY requirements.txt .
RUN pip3 install -r requirements.txt --user

# prod
from gcr.io/distroless/python3-debian11:debug as prod

COPY --from=prod-base /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY . /root/project
WORKDIR /root/project
ENTRYPOINT []
CMD ["python" , "main.py"]
