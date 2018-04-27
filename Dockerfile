FROM openjdk:8-jdk
MAINTAINER Kirill Filimonov <kirill.filimonov@gmail.com>

ENV ANDROID_TARGET_SDK="26" \
    ANDROID_BUILD_TOOLS="26.0.2" \
    ANDROID_SDK_TOOLS="26.0.2"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 

RUN git config --global user.email "<YOUR_EMAIL>"
RUN git config --global user.name "<YOUR_NAME>"

RUN apt-get --quiet install --yes python3-setuptools
RUN easy_install3 pip
RUN pip install -U pip
RUN git clone git://github.com/requests/requests.git 
RUN cd requests && pip install . && cd

RUN mkdir ~/.android
RUN touch ~/.android/repositories.cfg

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
   unzip android-sdk.zip -d ./android-sdk-linux

RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_TARGET_SDK}" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"

RUN echo y | android-sdk-linux/tools/bin/sdkmanager "extras;android;m2repository" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "extras;google;google_play_services" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "extras;google;m2repository" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"

ENV ANDROID_HOME $PWD/android-sdk-linux
