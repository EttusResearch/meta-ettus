#!/usr/bin/env python3

from setuptools import setup

setup(
    name='usrp_emb',
    version='0.0.1',
    description='USRP Embedded Tools',
    long_description='USRP Embedded Tools',
    url='https://github.com/EttusResearch',
    author='Michael Auchter',
    author_email='michael.auchter@ni.com',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Programming Language :: Python :: 3.7',
    ],
    keywords='usrp_emb',
    packages=['usrp_emb'],
    install_requires=[
        'PyYAML==5.4.1',
        'junit-xml==1.9',
        'paramiko==2.7.2',
        'pexpect==4.8.0',
        'psutil==5.8.0',
        'ptyprocess==0.7.0',
        'py3tftp==1.2.1',
        'pyroute2==0.5.14',
        'pyserial==3.5',
        'unittest-xml-reporting==3.0.4',
    ],
    entry_points={
        'console_scripts': [
            'usrp_emb_fetch_artifacts=usrp_emb.fetch_artifacts:main',
            'usrp_emb_bist_xml=usrp_emb.bist_results:main',
            'usrp_emb_x4xx_flash_scu=usrp_emb.test_x4xx:flash_scu',
            'usrp_emb_x4xx_flash_emmc=usrp_emb.test_x4xx:flash_emmc',
            'usrp_emb_x4xx_update_cpld=usrp_emb.test_x4xx:update_cpld',
            'usrp_emb_x4xx_boot_linux=usrp_emb.test_x4xx:boot_linux',
            'usrp_emb_x4xx_mender_update=usrp_emb.test_x4xx:mender_update',
            'usrp_emb_test_x4xx=usrp_emb.test_x4xx:embedded_tests',
            'usrp_emb_test_x4xx_mender=usrp_emb.test_x4xx:mender_tests',
        ]
    }
)
