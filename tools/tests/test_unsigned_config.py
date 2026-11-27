import importlib.util
from pathlib import Path
import tempfile
import unittest
spec=importlib.util.spec_from_file_location('unsigned',Path(__file__).parents[1]/'configure_unsigned_android.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
class UnsignedConfigTest(unittest.TestCase):
    def test_never_substitutes_a_debug_key_for_release_signing(self):
        with tempfile.TemporaryDirectory() as d:
            p=Path(d)/'build.gradle.kts'
            p.write_text('release { signingConfig = signingConfigs.getByName("debug") }')
            module.configure(p)
            self.assertIn('signingConfig = null',p.read_text())
            self.assertNotIn('getByName("debug")',p.read_text())
            before=p.read_bytes()
            with self.assertRaises(ValueError):module.configure(p)
            self.assertEqual(before,p.read_bytes())
