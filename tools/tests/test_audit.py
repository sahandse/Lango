import importlib.util
import pathlib
import subprocess
import tempfile
import unittest
import json
spec=importlib.util.spec_from_file_location('audit',pathlib.Path(__file__).parents[1]/'audit_farsimatrix.py')
module=importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
class AuditTest(unittest.TestCase):
    def test_audit_reports_issues_without_claiming_semantic_review(self):
        with tempfile.TemporaryDirectory() as d:
            root=pathlib.Path(d)
            subprocess.run(['git','init','-q',d],check=True)
            (root/'LICENSE').write_text('Apache License')
            (root/'README.md').write_text('[MIT](LICENSE)')
            groups=root/'public/data/groups';groups.mkdir(parents=True)
            (groups/'test.json').write_text(json.dumps([
                {'id':'1','word':'book','meanings':['کتاب']},
                {'id':'1','word':'BOOK','meanings':['book']},
                {'id':'3','word':'','meanings':[]}]))
            subprocess.run(['git','-C',d,'add','.'],check=True)
            subprocess.run(['git','-C',d,'-c','user.name=Test','-c','user.email=test@example.invalid','commit','-qm','fixture'],check=True)
            result=module.audit(root)
            self.assertEqual(result['totals'],{'entries':3,'duplicate_ids':1,'duplicate_terms':1,'no_arabic_script_letters':1,'invalid_entries':1})
            self.assertTrue(result['readme_claims_mit'])
            self.assertTrue(result['redistribution_status'].startswith('blocked'))
            self.assertEqual(result,module.audit(root))

    def test_unicode_presentation_forms_are_not_false_positive_flags(self):
        self.assertTrue(module.has_arabic_letters('ﻛﺘﺎﺏ'))
        self.assertTrue(module.has_arabic_letters('کتاب'))
        self.assertFalse(module.has_arabic_letters('۱۲۳'))
        self.assertFalse(module.has_arabic_letters('book'))
