sudo docker-compose -f docker-compose.test.yml run web \
     bash -c "bundle exec rails db:create db:schema:load && bundle exec rspec"
