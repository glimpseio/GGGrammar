import XCTest
@testable import GGSpec
import BricBrac
import Curio

final class GGSpecTests: XCTestCase {
    func testDecoding() {
        XCTAssertEqual(["XYZ"], try Bric.parse("[\"XYZ\"]"))
    }

    func testCurio() {
        let _ = Curio()
    }
}
