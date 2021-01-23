all:
	mkdir -p app
	elm make src/Background.elm --output=app/Elm.js
	cp src/manifest.json src/background.js app/
	cp -r img/ app/

clean:
	rm -rf app/
