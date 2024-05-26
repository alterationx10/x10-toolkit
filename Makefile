.PHONY: x10-bundle x10-publish local clean

clean:
	rm -rf x10-bundle

x10-bundle:
	mkdir -p x10-bundle/dev/alteration/x10/toolkit_3/${TOOLKIT_VERSION}
	mkdir -p x10-bundle/dev/alteration/x10/toolkit-test_3/${TOOLKIT_VERSION}
	scala-cli --power publish local X10Toolkit.scala publish-conf.scala --gpg-key ${PGP_KEY_ID} --gpg-option --pinentry-mode --gpg-option loopback --gpg-option --passphrase --gpg-option ${PGP_PASSPHRASE}
	scala-cli --power publish local --dependency "dev.alteration.x10::toolkit::${TOOLKIT_VERSION}" X10ToolkitTest.scala publish-conf.scala --gpg-key ${PGP_KEY_ID} --gpg-option --pinentry-mode --gpg-option loopback --gpg-option --passphrase --gpg-option ${PGP_PASSPHRASE}
	for DIR in srcs docs poms jars; do \
		cp  ~/.ivy2/local/dev.alteration.x10/toolkit_3/${TOOLKIT_VERSION}/$$DIR/* x10-bundle/dev/alteration/x10/toolkit_3/${TOOLKIT_VERSION}; \
		cp  ~/.ivy2/local/dev.alteration.x10/toolkit-test_3/${TOOLKIT_VERSION}/$$DIR/* x10-bundle/dev/alteration/x10/toolkit-test_3/${TOOLKIT_VERSION}; \
	done
	cd x10-bundle/dev/alteration/x10/toolkit_3/${TOOLKIT_VERSION} && \
		rename 's/toolkit_3/toolkit_3-${TOOLKIT_VERSION}/' *
	cd x10-bundle/dev/alteration/x10/toolkit-test_3/${TOOLKIT_VERSION} && \
		rename 's/toolkit-test_3/toolkit-test_3-${TOOLKIT_VERSION}/' *
	cd x10-bundle && \
		zip -r x10-toolkit-${TOOLKIT_VERSION}.zip .
	
x10-publish:
	curl \
            --request POST \
            --header 'Authorization: Bearer ${CENTRAL_TOKEN}' \
            --form bundle=@x10-bundle/x10-toolkit-${TOOLKIT_VERSION}.zip \
            https://central.sonatype.com/api/v1/publisher/upload?publishingType=AUTOMATIC
local:
	scala-cli publish local X10Toolkit.scala publish-conf.scala
	scala-cli publish local X10ToolkitTest.scala publish-conf.scala

	scala-cli publish local X10NativeToolkit.scala publish-conf.scala
	scala-cli publish local X10NativeToolkitTest.scala publish-conf.scala

	scala-cli publish local --native X10NativeToolkit.scala X10NativeToolkit.native.scala publish-conf.scala
	scala-cli publish local --native X10NativeToolkitTest.scala publish-conf.scala
