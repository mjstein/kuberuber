FROM centos:7
RUN yum install ruby ruby-devel gcc-c++ make -y 
RUN gem install sinatra thin
RUN mkdir app
COPY code/* app
WORKDIR app
ENTRYPOINT ruby main.rb
EXPOSE 8080
