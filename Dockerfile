# Start from the code-server Debian base image
FROM codercom/code-server:latest 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# RUN rclone config
# RUN cat $(rclone config file | sed -n 2p) | base64 --wrap=0

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment here. Some examples:
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension CoenraadS.bracket-pair-colorizer
RUN code-server --install-extension mikestead.dotenv
RUN code-server --install-extension christian-kohler.path-intellisense

# Install nodejs
RUN sudo apt-get install -y nodejs
RUN sudo apt install -y npm

RUN git config --global user.name "felixwong"
RUN git config --global user.email "felix011018@gmail.com"
# RUN sudo apt-get install -y build-essential
# RUN COPY myTool /home/coder/myTool



# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
