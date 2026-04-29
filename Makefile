WORKSPACE = Momentum.xcworkspace
SCHEME    = Momentum
DEST      = platform=iOS Simulator,name=iPhone 17 Pro,OS=latest

.PHONY: generate build test clean lint spm-test-all spm-test-core spm-test-domain spm-test-data spm-test-presentation

generate:
	xcodegen

build: generate
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) \
	  -sdk iphonesimulator -destination "$(DEST)" \
	  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
	  build

test: generate
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) \
	  -sdk iphonesimulator -destination "$(DEST)" \
	  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
	  -enableCodeCoverage YES \
	  test

clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/MomentumApp-*

lint:
	swiftlint

spm-test-core:
	cd Packages/Core && swift test

spm-test-domain:
	cd Packages/Domain && swift test

spm-test-data:
	cd Packages/Data && swift test

spm-test-presentation:
	cd Packages/Presentation && swift test

spm-test-all: spm-test-core spm-test-domain spm-test-data spm-test-presentation
