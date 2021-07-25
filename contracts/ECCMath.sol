pragma solidity ^0.4.18;

library ECCMath {
  /// @dev Modular inverse of a (mod p) using euclid.
  /// "a" and "p" must be co-prime.
  /// @param a The number.
  /// @param p The mmodulus.
  /// @return x such that ax = 1 (mod p)
  function invmod(uint a, uint p) internal pure returns (uint) {
    require(a != 0 && a != p && p != 0);
    if (a > p)
      a = a % p;
    int t1;
    int t2 = 1;
    uint r1 = p;
    uint r2 = a;
    uint q;
    while (r2 != 0) {
      q = r1 / r2;
      (t1, t2, r1, r2) = (t2, t1 - int(q) * t2, r2, r1 - q * r2);
    }
    if (t1 < 0)
      return (p - uint(- t1));
    return uint(t1);
  }

  /// @dev Modular exponentiation, b^e % m
  /// @param b The base.
  /// @param e The exponent.
  /// @param m The modulus.
  /// @return x such that x = b**e (mod m)
  function expmod(uint b, uint e, uint m) internal constant returns (uint r) {
    if (b == 0)
      return 0;
    if (e == 0)
      return 1;
    require(m != 0);
    r = 1;
    uint bit = 2 ** 255;
    bit = bit;
    assembly {
      loop :
      jumpi(end, iszero(bit))
      r := mulmod(mulmod(r, r, m), exp(b, iszero(iszero(and(e, bit)))), m)
      r := mulmod(mulmod(r, r, m), exp(b, iszero(iszero(and(e, div(bit, 2))))), m)
      r := mulmod(mulmod(r, r, m), exp(b, iszero(iszero(and(e, div(bit, 4))))), m)
      r := mulmod(mulmod(r, r, m), exp(b, iszero(iszero(and(e, div(bit, 8))))), m)
      bit := div(bit, 16)
      jump(loop)
      end :
    }
  }

  /// @dev Converts a point (Px, Py, Pz) expressed in Jacobian coordinates to (Px", Py", 1).
  /// Mutates P.
  /// @param P The point.
  /// @param zInv The modular inverse of "Pz".
  /// @param z2Inv The square of zInv
  /// @param prime The prime modulus.
  /// @return (Px", Py", 1)
  function toZ1(uint[3] memory P, uint zInv, uint z2Inv, uint prime) internal pure {
    P[0] = mulmod(P[0], z2Inv, prime);
    P[1] = mulmod(P[1], mulmod(zInv, z2Inv, prime), prime);
    P[2] = 1;
  }

  /// @dev See _toZ1(uint[3], uint, uint).
  /// Warning: Computes a modular inverse.
  /// @param PJ The point.
  /// @param prime The prime modulus.
  /// @return (Px", Py", 1)
  function toZ1(uint[3] PJ, uint prime) internal pure {
    uint zInv = invmod(PJ[2], prime);
    uint zInv2 = mulmod(zInv, zInv, prime);
    PJ[0] = mulmod(PJ[0], zInv2, prime);
    PJ[1] = mulmod(PJ[1], mulmod(zInv, zInv2, prime), prime);
    PJ[2] = 1;
  }

}