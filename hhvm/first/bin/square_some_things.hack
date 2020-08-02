#!/usr/bin/env hhvm

require_once(__DIR__ . '/../vendor/autoload.hack');


<<__EntryPoint>>
async function main(): Awaitable<void> {
    \Facebook\AutoloadMap\initialize();

    $squared = square_vec(vec[1, 2, 3, 4, 5]);
    foreach ($squared as $squared) {
        printf("%d\n", $squared);
    }
}