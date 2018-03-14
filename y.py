import yaml, sys, pprint
pprint.pprint(list(yaml.load_all(sys.stdin)))
