#!/usr/bin/env python3

import os
import sys
import subprocess
import platform
import shutil
import venv
from pathlib import Path

def check_python_version():
    """
    Verify Python version meets minimum requirements
    
    Returns:
    bool: True if version is sufficient, False otherwise
    """
    version_info = sys.version_info
    min_version = (3, 7)
    
    if version_info < min_version:
        print(f"Error: Python {'.'.join(map(str, min_version))} or higher is required.")
        print(f"Current version: {sys.version}")
        return False
    return True

def create_virtual_environment():
    """
    Create a virtual environment in the project directory
    
    Returns:
    bool: True if virtual environment created successfully, False otherwise
    """
    try:
        # Use Path for cross-platform path handling
        project_dir = Path(__file__).resolve().parent
        venv_path = project_dir / 'venv'
        
        # Ensure clean slate
        if venv_path.exists():
            print("Removing existing virtual environment...")
            shutil.rmtree(venv_path, ignore_errors=True)
        
        # Create virtual environment
        print("Creating virtual environment...")
        venv.create(str(venv_path), with_pip=True)
        
        return True
    except Exception as e:
        print(f"Error creating virtual environment: {e}")
        print(f"Current working directory: {os.getcwd()}")
        print(f"Script location: {__file__}")
        return False

def install_dependencies():
    """
    Install project dependencies
    
    Returns:
    bool: True if dependencies installed successfully, False otherwise
    """
    try:
        # Use Path for cross-platform path handling
        project_dir = Path(__file__).resolve().parent
        
        # Determine pip path based on virtual environment
        if platform.system() == "Windows":
            pip_path = str(project_dir / 'venv' / 'Scripts' / 'pip')
        else:
            pip_path = str(project_dir / 'venv' / 'bin' / 'pip')
        
        # Ensure pip path exists
        if not os.path.exists(pip_path):
            print(f"Pip not found at {pip_path}")
            return False
        
        # Upgrade pip
        subprocess.check_call([pip_path, 'install', '--upgrade', 'pip'])
        
        # Install requirements
        requirements_path = project_dir / 'requirements.txt'
        
        if requirements_path.exists():
            subprocess.check_call([pip_path, 'install', '-r', str(requirements_path)])
        else:
            # Fallback dependencies if no requirements.txt
            dependencies = [
                'pandas',
                'tabula-py',
                'PyMuPDF',
                'openpyxl',
                'odfpy'
            ]
            subprocess.check_call([pip_path, 'install'] + dependencies)
        
        return True
    except subprocess.CalledProcessError as e:
        print(f"Dependency installation failed: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error during dependency installation: {e}")
        print(f"Error details: {traceback.format_exc()}")
        return False

def verify_installation():
    """
    Verify that dependencies are correctly installed
    
    Returns:
    bool: True if verification successful, False otherwise
    """
    # Use the virtual environment's Python to verify
    try:
        # Determine Python path
        project_dir = Path(__file__).resolve().parent
        if platform.system() == "Windows":
            python_path = str(project_dir / 'venv' / 'Scripts' / 'python')
        else:
            python_path = str(project_dir / 'venv' / 'bin' / 'python')
        
        # Run verification in the virtual environment
        result = subprocess.run(
            [python_path, '-c', 
             'import pandas; import tabula; import fitz; print("Dependencies verified!")'], 
            capture_output=True, 
            text=True
        )
        
        if result.returncode == 0:
            print("All dependencies verified successfully!")
            return True
        else:
            print("Verification failed:")
            print(result.stderr)
            return False
    except Exception as e:
        print(f"Verification error: {e}")
        return False

def main():
    """
    Main setup script execution
    """
    print("Inventory Data Extractor - Setup")
    print("--------------------------------")

    # Check Python version
    if not check_python_version():
        sys.exit(1)

    # Create virtual environment
    if not create_virtual_environment():
        print("Virtual environment creation failed.")
        sys.exit(1)

    # Install dependencies
    if not install_dependencies():
        print("Dependency installation failed.")
        sys.exit(1)

    # Verify installation
    if not verify_installation():
        print("Installation verification failed.")
        sys.exit(1)

    # Provide activation instructions
    print("\nTo activate the virtual environment:")
    if platform.system() == "Windows":
        print("Run: venv\\Scripts\\activate")
    else:
        print("Run: source venv/bin/activate")

    print("\nSetup completed successfully!")

if __name__ == "__main__":
    main()
