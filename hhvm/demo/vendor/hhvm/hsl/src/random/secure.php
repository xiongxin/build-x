<?hh // strict
/*
 *  Copyright (c) 2004-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace HH\Lib\SecureRandom;

use namespace HH\Lib\{_Private, Math, Str};

/**
 * Returns a cryptographically secure random float in the range from 0.0 to 1.0,
 * inclusive.
 *
 * For pseudorandom floats, see `PseudoRandom\float`.
 */
<<__NonRx('Randomness')>>
function float(): float {
  return (float)(namespace\int(0, Math\INT53_MAX) / Math\INT53_MAX);
}

/**
 * Returns a cryptographically secure random integer in the range from `$min` to
 * `$max`, inclusive.
 *
 * For pseudorandom integers, see `PseudoRandom\int`.
 */
<<__NonRx('Randomness')>>
function int(
  int $min = \PHP_INT_MIN,
  int $max = \PHP_INT_MAX,
): int {
  invariant(
    $min <= $max,
    'Expected $min (%d) to be less than or equal to $max (%d).',
    $min,
    $max,
  );
  return _Private\Native\random_int($min, $max);
}

/**
 * Returns a securely generated random string of length `$length`. The string is
 * composed of characters from `$alphabet` if `$alphabet` is specified.
 *
 * For pseudorandom strings, see `PseudoRandom\string`.
 */
<<__NonRx('Randomness')>>
function string(
  int $length,
  ?string $alphabet = null,
): string {
  return _Private\random_string(
    /* HH_FIXME[2049] calling stdlib directly */
    /* HH_FIXME[4107] calling stdlib directly */
    ($length) ==> \random_bytes($length),
    $length,
    $alphabet,
  );
}
