from setuptools import setup

with open('README.rst') as f:
    long_description = f.read()

with open('LICENCE.txt') as f:
    licence = f.read()
        
setup(
    name='prov',
    version='0.4.0',
    author='Trung Dong Huynh',
    author_email='trungdong@donggiang.com',
    packages=['prov', 'prov.model', 'prov.persistence', 'prov.tracking', 'prov.model.test', 'prov.tracking.test'],
    scripts=[],
    url='http://github.com/trungdong/w3-prov/tree/master/provpy',
    license=licence,
    description='A Python implementation of PROV data model providing simple provenance tracking and persistence using Django.',
    long_description=long_description,
    provides='prov',
    keywords=['provenance', 'model', 'persistence', 'tracking', 'PROV', 'PROV-DM', 'PROV-JSON'],
    classifiers=[
          'Development Status :: 4 - Beta',
          'Environment :: Console',
          'Environment :: Web Environment',
          'Framework :: Django',
          'Intended Audience :: Developers',
          'Intended Audience :: Information Technology',
          'License :: OSI Approved :: BSD License',
          'Operating System :: OS Independent',
          'Programming Language :: Python :: 2.6',
          'Topic :: Scientific/Engineering :: Information Analysis',
          'Topic :: Security',
          'Topic :: System :: Logging',
          ],
)