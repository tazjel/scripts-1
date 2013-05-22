import fnDeployer
import fileinput
import argparse

parser = argparse.ArgumentParser(prog='valordep')
parser.add_argument('-e', metavar='--enviroment', nargs='+', required=1, action='store', help='Environment to apply the package files.')
parser.add_argument('-b', metavar='--backup', nargs=1, action='store', help='Make backup of files.')

args = parser.parse_args()


print fnEnviron(args.e).split()

ArqTxt = 'lista.txt'
Lista = fileinput.input([ArqTxt])
