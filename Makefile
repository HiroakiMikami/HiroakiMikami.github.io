.PHONY: bootstrap install server clean

bootstrap:
	bundle update

install:
	bundle install

serve:
	bundle exec jekyll serve --no-watch

build:
	bundle exec jekyll build

clean:
	bundle exec jekyll clean
	rm -rf vendor Gemfile.lock

deploy:
	./bin/deploy.sh
