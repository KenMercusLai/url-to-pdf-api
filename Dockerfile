# Partially copied from https://github.com/ebidel/try-puppeteer/tree/4b68714dee5492b77a0fd6711d3abaf8bc72d995/backend
FROM node:10-slim
ENV DEBIAN_FRONTEND noninteractive

# Install latest chrome dev package.
# Note: this installs the necessary libs to make the bundled version of
# Chromium that Puppeteer installs, work.

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libx11-6 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 libglib2.0-0 libnss3 libcups2 libasound2 libatk1.0-0 libatk-bridge2.0-0 libpangocairo-1.0-0 libgtk-3-0 

# Add pptr user.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/ \
    && chown -R pptruser:pptruser /home/pptruser 

COPY . /home/pptruser
WORKDIR /home/pptruser

RUN mkdir -p /home/pptruser/Downloads

RUN npm install


# RUN fc-cache -f -v

# # Install deps for server.
# # Cache bust so we always get the latest version of puppeteer when
# # building the image.
# ARG CACHEBUST=1
# RUN yarn

# # Uncomment to skip the chromium download when installing puppeteer.
# # ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true



# # Run user as non privileged.
USER pptruser

EXPOSE 9000
CMD ["npm", "start"]