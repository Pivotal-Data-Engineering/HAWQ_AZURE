import jinja2
import json
import os.path
import subprocess
import sys

TEMPLATE_NAME='hdb-dl-ambari-azure.json.tpl'

def renderTemplate(templateFile, context):
    env = jinja2.Environment()
    env.trim_blocks = True
    env.lstrip_blocks = True
    outputFile = templateFile[:-4]
    with open(templateFile,'r') as f:
      templateStr = f.read()
    
    template = jinja2.Template(templateStr)
    with open(outputFile, 'w') as outf:
        template.stream(context).dump(outf)
        

if __name__ == '__main__':
   here = os.path.dirname(os.path.abspath(__file__))
   envFile = os.path.join(here,'env.json')
   templateFile = os.path.join(here,TEMPLATE_NAME)
   
   if not os.path.isfile(envFile):
      sys.exit('Exiting because the required file "{0}" was not found'.format(envFile))
      
   if not os.path.isfile(templateFile):
      sys.exit('Exiting because the required file "{0}" was not found'.format(templateFile))
      
   with open(envFile,'r') as f:
      env = json.load(f)
      
   print 'loaded environment file: {0}'.format(envFile)
   
   rgName = env['resourceGroupName']
   subprocess.check_call(['azure','group','create','-n',rgName,'-l', env['location']])
   
   renderTemplate(templateFile, env)
   
   subprocess.check_call(['azure','group','deployment','create','-d','All', '-g', rgName, '-f', templateFile[:-4]])
   
  
      
         