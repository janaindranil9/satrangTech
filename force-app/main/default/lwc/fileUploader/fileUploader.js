import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFileToGoogleDrive from '@salesforce/apex/FileUploaderController.uploadFileToGoogleDrive';
import createChildRecords from '@salesforce/apex/FileUploaderController.createChildRecord';
 
export default class FileUploader extends LightningElement {
  @track selectedFile;
  @track isUploadDisabled = true;
  handleFileChange(event) {
    this.selectedFile = event.target.files[0];
    this.isUploadDisabled = !(this.selectedFile && this.validateFileSize(this.selectedFile));
  }

  validateFileSize(file) {
    const fileSizeInMB = file.size / (1024 * 1024);
    return fileSizeInMB >= 5 && fileSizeInMB <= 16;
  }

  uploadFile() {
    const reader = new FileReader();
    reader.onloadend = () => {
      const fileContents = reader.result;
      const base64Data = 'base64,' + btoa(this.selectedFile);

      uploadFileToGoogleDrive({ fileName: this.selectedFile.name, base64Data })
        .then(result => {
          const fileId = result.fileId;
          // Retrieve file metadata using Google Drive API if needed
          createChildRecords({ parentId: 'yourParentRecordId', fileId })
            .then(() => {
              // Child records created successfully
              this.selectedFile = null;
              this.isUploadDisabled = true;
              // Show success message or perform any other necessary actions
              this.showToast('Success', 'Child records created successfully.', 'success');
            })
            .catch(error => {
              // Handle child record creation error
              this.showToast('Error', 'Error creating child records.', 'error');
            });
        })
        .catch(error => {
          // Handle file upload error
          console.log('error uploading ',error);
          this.showToast('Error', 'Error Uploading file.', 'error');
        });
    };
    reader.readAsBinaryString(this.selectedFile);
  }
  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant,
    });
    this.dispatchEvent(event);
}
}