from hyphen import hslowlevel

module_cache = {}

def fetch_lib_module(name):
    if name not in module_cache:
        if name == 'prim':
            module_cache[name] = hslowlevel.access_basics()
        else:
            load_module(name)

    return module_cache[name]

def load_module(*names):
    module_cache.update(hslowlevel.import_lib(*names))

def fetch_source_modules(paths):
    module_cache.update(hslowlevel.import_src(*paths))
