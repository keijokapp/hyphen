import module from 'module';

const require = module.createRequire(import.meta.url);

const native = require('./haskell.node');

for (;;) {
	native.doSomethingUseful();
}
