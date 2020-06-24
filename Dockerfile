FROM ruby:2.7

WORKDIR /opt/ESPN-FF-Robot/lib

COPY . /opt/ESPN-FF-Robot

VOLUME /var/log

RUN bundle install

CMD ruby ./espn-ff-robot.rb -c set_lineup --config ../conf.json