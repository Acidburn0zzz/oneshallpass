
var state = {
    seed : [],
    last_n : [],
    getFocus : false,
    randshorts : [],
    prev : [],
    security_param : 58
};

function $(n) { return document.getElementById(n); }

function acceptFocus(event) {
    var se = event.srcElement;
    if (!state.gotFocus) {
	se.value = "";
	state.gotFocus = true;
    }
}

function entropyChanged(event) {
    state.security_param = event.srcElement.value;
    maybe_generate();
}

function generate_pw() {
    var n = Math.ceil(state.security_param / log2(dict.words.length));
    var w = [];
    var i;
    for (i = 0; i < n; i++) {
	w.push (dict.words[gen1(dict.words.length)]);
    }
    return w.join(" ");
}

function generate() {
    var n = 1;
    var pws = [];
    var i;
    $("pw-status").style.display = "none";
    for (i = 0; i < n; i++) {
	var el = $("pw-" + i);
	el.style.display = "inline-block";
	el.firstChild.nodeValue = generate_pw();
    }
}

function maybe_generate() {
    
	var l = state.seed.length / 2;
    if (l > 0) {
	    var txt;
	    if (l > state.security_param) {
            txt = "...computing...";
            generate();
        } else {
            txt = "Collected " + l + " of " + state.security_param + "; need MORE!";
        }
        $("pw-status").firstChild.nodeValue = txt;
    }
}


function gotInput (event) {
    var se = event.srcElement;

    var kc = event.keyCode;

    var found = false;
    var n = 5;
    for (i = 0; i < n && !found; i++) {
	if (state.last_n[i] == kc) {
	    found = true;
	}
    }

    if (!found) {
	var v = state.last_n;
    if (v.length == n) {
        v = v.slice(1);
    }
	v.push(kc);
	state.last_n = v;
	state.seed.push(new Date().getTime() % 100);
	state.seed.push(event.keyCode);
    maybe_generate();
    }
}

function sha_to_shorts (input) {
    var digest = CryptoJS.SHA512(input);
    var out = [];
    var i;
    for (i = 0; i < digest.words.length; i++) {
	word = digest.words[i];
	out.push(word & 0xffff);
	out.push((word >> 16) + 0x7fff);
    }
    console.log ("sha_to_shorts: " + input + " -> " + out.toString());
    return out;
}

function _gen1 () {
    if (state.randshorts.length === 0) {
	var input = state.seed.concat(state.lasthash);
	var v = sha_to_shorts(input.toString());
	state.lasthash = v.slice(0);
	state.randshorts = v;
    }
    var x = state.randshorts.pop();
    console.log ("_gen1() -> " + x);
    return x;
}

function log2(x) {
    return Math.log(x) / Math.log(2);
}

function gen1(hi) {
    console.log ("hi = " + hi);
    var nbits = Math.ceil(log2(hi));
    var res = -1;
    console.log ("nibts: " + nbits);
    var mask = ~(0x7fffffff << nbits);
    console.log ("mask: " +  mask);
    while (res < 0 || res >= hi) {
	res = _gen1() & mask;
    }
    console.log ("gen1() -> " + res);
    return res;
}

    
