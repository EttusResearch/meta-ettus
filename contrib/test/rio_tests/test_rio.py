#!/usr/bin/env python

import riodrivertests.pyratstest_controls_indicators as test_ci
import riodrivertests.pyratstest_download as test_download
import riodrivertests.pyratstest_interrupt_stress as test_irq_stress
import riodrivertests.pyratstest_irq_correctness as test_irq_correctness
import riodrivertests.pyratstest_open as test_open
import riodrivertests.pyratstest_private as test_private
import riodrivertests.pyratstest_reset as test_reset
import riodrivertests.pyratstest_run_and_abort as test_run_abort
import riodrivertests.basicbehavior.pyratstest_buffer_wraparound as test_fifo_wrap
import riodrivertests.dataintegrity.pyratstest_data_integrity as test_data_integrity
import riodrivertests.dataintegrity.pyratstest_zc_data_integrity as test_zc_data
import riodrivertests.dataintegrity.pyratstest_max_fifos as test_max_fifos
import riodrivertests.varyingpayload.pyratstest_varying_payload as test_varying_payload
import riodrivertests.zerocopy.pyratstest_mixtrad_zc as test_fifo_mixtrad_zc
import riodrivertests.multichannel.pyratstest_multi_input as test_multi_input
import riodrivertests.multichannel.pyratstest_multi_output as test_multi_output
import riodrivertests.multichannel.pyratstest_zc_multi_input as test_zc_multi_input
import riodrivertests.configure.pyratstest_acquire_read_timeout as test_timeout
import riodrivertests.configure.pyratstest_read_timeout as test_read_timeout
import riodrivertests.configure.pyratstest_read_zero as test_read_zero
import riodrivertests.configure.pyratstest_configure as test_configure
import unittest
import os.path

target = "USRP-X410"
bitfile_path = "/usr/share/x4xx-pyrats-bitfiles"
projects = [
    'all32irqs',
    'allregistertypes',
    'allregistertypes_autorunwhenloaded',
    'dataintegrity_u32',
    'dataintegrity_u64',
    'interruptstress',
    'maxfifos',
    'multiinputoutput',
    'runforxmilliseconds',
]
bitfiles = {proj: os.path.join(bitfile_path, "{}_{}.lvbitx".format(target, proj)) for proj in projects}

resource = 'nirio0'

fpga = {
    'fpga-name': resource,
    'fifo-wait-strategy': 'polling',
    'bus-asic': 'inchworm',
}

host = {
    'memory-megabytes': 4000,
}

class PyratsTest(unittest.TestCase):
    def __init__(self, method):
        if method.__code__.co_argcount == 2:
            setattr(self, method.__name__, lambda: method(bitfiles, resource))
        else:
            setattr(self, method.__name__, lambda: method(bitfiles, fpga, host))
        super(PyratsTest, self).__init__(method.__name__)


def load_tests(loader, tests, pattern):
    suite = unittest.TestSuite()

    open_tests = [
        test_open.test_open_close,
        test_open.test_invalid_target,
        test_open.test_personality_locking_open_close,
        test_open.test_personality_lock_protection,
    ]

    private_tests = [
        test_private.test_find_registers_errors,
        test_private.test_find_all_fifos,
        test_private.test_find_fifo_errors,
    ]

    reset_tests = [
        test_reset.test_reset,
        test_reset.test_close_not_last_session_does_not_reset,
        test_reset.test_close_last_session_does_reset,
        test_reset.test_close_not_reset_and_reopen_is_not_reset,
    ]

    run_abort_tests = [
        test_run_abort.test_abort_stops_the_fpga_vi_without_resetting_controls_and_indicators,
        test_run_abort.test_can_rerun_an_aborted_fpga_vi,
        test_run_abort.test_can_rerun_a_naturally_stopped_fpga_vi,
        test_run_abort.test_run_with_wait_until_done_attribute_actually_waits_until_done,
        test_run_abort.test_open_that_has_to_download_will_run_the_vi,
        test_run_abort.test_open_that_does_not_have_to_download_will_run_the_vi,
        test_run_abort.test_open_that_does_not_have_to_download_runs_a_stopped_autorun_when_loaded_fpga_vi,
        test_run_abort.test_open_autorun_after_previous_reset_should_ensure_running,
        test_run_abort.test_open_with_the_no_run_attribute_does_not_run_the_vi,
        test_run_abort.test_get_already_running_warning_if_you_run_an_fpga_vi_that_is_already_running,
    ]

    ci_tests = [
        test_ci.test_single_less_than_or_equal_to_32bit,
        test_ci.test_single_64bit,
        test_ci.test_array_greater_than_32bit,
        test_ci.test_array_less_than_or_equal_to_32bits,
        test_ci.test_register_on_external_clock_domain_CAPI,
        # disabled due to FakeLabVIEWSession not managing lifetimes correctly:
        #test_ci.test_register_on_external_clock_domain_static_mode,
    ]

    download_tests = [
        test_download.test_download,
        test_download.test_download_does_not_run,
    ]

    irq_tests = [
        test_irq_correctness.test_basic_irq_timeout,
        test_irq_correctness.test_irq_large_timeout,
        test_irq_correctness.test_basic_irq_assertion,
        test_irq_stress.test_interrupt_stress,
    ]

    def test_fifo_data_integrity_u32(bitfiles, resource):
        one_bitfile = {}
        one_bitfile['dataintegrity_u32'] = bitfiles['dataintegrity_u32']
        test_data_integrity.test_fifo_data_integrity(one_bitfile, resource)

    def test_fifo_data_integrity_u64(bitfiles, resource):
        one_bitfile = {}
        one_bitfile['dataintegrity_u64'] = bitfiles['dataintegrity_u64']
        test_data_integrity.test_fifo_data_integrity(one_bitfile, resource)

    fifo_tests = [
        test_fifo_data_integrity_u64,
        test_fifo_data_integrity_u32,
        test_fifo_wrap.test_buffer_wraparound,
        test_zc_data.test_fifo_zc_data_integrity,
        test_varying_payload.test_fifo_varying_payload,
        test_fifo_mixtrad_zc.test_fifo_mix_traditional_and_zero_copy,
        test_multi_input.test_fifo_multi_input,
        test_multi_output.test_fifo_multi_output,
        test_zc_multi_input.test_fifo_zc_multi_input,
        test_timeout.test_acquire_read_timeout,
        test_read_timeout.test_fifo_read_long_timeout,
        test_read_timeout.test_fifo_read_timeout,
        test_read_zero.test_fifo_read_zero,
        test_configure.test_configure_input_output_with_data_integrity,
        test_configure.test_configure_then_start_stop_input,
        test_configure.test_configure2_zero_depth_bad_depth_error,
        test_max_fifos.test_max_fifos,
        test_configure.test_out_of_memory_error_when_allocation_fails,
        test_configure.test_configure2_max_depth_okay,
        test_configure.test_configure2_above_max_depth_fails,
    ]

    test_groups = [
        open_tests,
        private_tests,
        reset_tests,
        run_abort_tests,
        ci_tests,
        download_tests,
        irq_tests,
        fifo_tests,
    ]

    for group in test_groups:
        for test in group:
            suite.addTest(PyratsTest(test))

    return suite

if __name__ == '__main__':
    unittest.main()

