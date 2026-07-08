use strings;

export fn atouint(s: str) u32 = {
    let res: u32 = 0;

    let a: []u8 = strings::toutf8(s);
    let la: size = len(a);

    for(let i: size = 0; i < la; i += 1) {
        res += (i: u32) * 10 + (a[i] - '0');
        la -= 1;
    };
    return res;
};

export fn pow(a: u32, b: u32) u32 = {
    if (b == 0) {
        return 1;
    };
    let half: u32 = pow(a, b / 2);

    if (b % 2 == 0) {
        return half * half;
    };

    return half * half * a;
};
