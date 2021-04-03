.PHONY: bootstrap install server clean

bootstrap:
	bundle update

install:
	bundle install

serve:
	bundle exec jekyll serve

clean:
	bundle exec jekyll clean
	rm -rf vendor Gemfile.lock

deploy:
	./scripts/deploy.sh
