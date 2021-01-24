all:
	mkdir -p app
	elm make src/*.elm --output=app/Elm.js
	cp src/manifest.json src/*.js app/
	cp -r img/ app/

clean:
	rm -rf app/
