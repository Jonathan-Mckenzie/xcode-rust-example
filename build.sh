MY_CRATE=rustylib
SWIFT_PROJECT=swiftyrustlib
SWIFT_PROJECT_NAME=RustyLib
SWIFT_CORE_NAME=RustyCore

cd $MY_CRATE

# step 1 - compile rust library and generate bindings
HEADERPATH="out/${MY_CRATE}FFI.h"
TARGETDIR="target"
OUTDIR="../${MY_CRATE}"
RELDIR="release"
STATIC_LIB_NAME="lib${MY_CRATE}.a"
NEW_HEADER_DIR="out/include"

targets=("aarch64-apple-ios" "aarch64-apple-ios-sim" "aarch64-apple-darwin")

for target in "${targets[@]}"; do
    cargo build --target "${target}" --release
    cargo run --bin uniffi-bindgen generate --library target/${target}/release/lib${MY_CRATE}.a --language swift --out-dir out
done

# step 2 - create xcframework
mkdir -p "${NEW_HEADER_DIR}"
cp "${HEADERPATH}" "${NEW_HEADER_DIR}/"
cp "out/${MY_CRATE}FFI.modulemap" "${NEW_HEADER_DIR}/module.modulemap"

rm -rf "${OUTDIR}/${MY_CRATE}_framework.xcframework"

xcodebuild -create-xcframework \
    -library "${TARGETDIR}/aarch64-apple-ios/${RELDIR}/${STATIC_LIB_NAME}" -headers "${NEW_HEADER_DIR}" \
    -library "${TARGETDIR}/aarch64-apple-ios-sim/${RELDIR}/${STATIC_LIB_NAME}" -headers "${NEW_HEADER_DIR}" \
    -library "${TARGETDIR}/aarch64-apple-darwin/${RELDIR}/${STATIC_LIB_NAME}" -headers "${NEW_HEADER_DIR}" \
    -output "${OUTDIR}/${MY_CRATE}_framework.xcframework"

rm -rf "${NEW_HEADER_DIR}"

# step 3 - move to SwiftLib artifacts
if [ -d "../${SWIFT_PROJECT}/artifacts" ]; then
    rm -rf "../${SWIFT_PROJECT}/artifacts"
fi
mkdir "../${SWIFT_PROJECT}/artifacts"
cp -R "${OUTDIR}/${MY_CRATE}_framework.xcframework" "../${SWIFT_PROJECT}/artifacts"
mv "../${SWIFT_PROJECT}/artifacts/${MY_CRATE}_framework.xcframework" "../${SWIFT_PROJECT}/artifacts/${SWIFT_CORE_NAME}.xcframework"

# step 4 - move to SwiftLib Sources
if [ -d "../${SWIFT_PROJECT}/Sources" ]; then
    rm -rf "../${SWIFT_PROJECT}/Sources"
fi
mkdir "../${SWIFT_PROJECT}/Sources"
mkdir "../${SWIFT_PROJECT}/Sources/${SWIFT_PROJECT_NAME}"
cp "${OUTDIR}/out/${MY_CRATE}.swift" "../${SWIFT_PROJECT}/Sources/${SWIFT_PROJECT_NAME}/${SWIFT_PROJECT_NAME}.swift"
