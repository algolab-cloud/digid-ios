import Foundation

/// The digid model files shipped as a SwiftPM resource bundle.
///
///     let kyc = try NidaKyc(modelDirectory: DigidModels.directory)
public enum DigidModels {
    /// Directory holding `ocr_det.nnef.tgz`, `ocr_rec.nnef.tgz`, `ocr_rec.dict.txt`,
    /// `face_det.nnef.tgz` and `face_rec.nnef.tgz`.
    public static var directory: URL {
        guard let url = Bundle.module.url(forResource: "digid-models", withExtension: nil) else {
            fatalError("digid-models missing from the DigidModels bundle; run scripts/build-ios.sh")
        }
        return url
    }
}
