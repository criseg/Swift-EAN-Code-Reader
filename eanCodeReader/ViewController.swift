//
//  ViewController.swift
//  eanCodeReader
//
//  Created by cmb on 15/11/2016.
//  Copyright © 2016 cmb. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func scanBtnClick(_ sender: Any) {
        
        self.scan()
        
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func scan()
    {
        captureSession = AVCaptureSession()
        
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let vidInput: AVCaptureDeviceInput
        
        do {
            vidInput = try AVCaptureDeviceInput(device: videoDevice)
        }
        catch {
            print("error")
            return
        }
        
        if(captureSession.canAddInput(vidInput))
        {
            captureSession.addInput(vidInput)
        }
        else
        {
            outputLabel.text = "error can not add input"
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if(captureSession.canAddOutput(metaDataOutput))
        {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        }
        else
        {
            outputLabel.text = "error can not add meta data"
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
        /*
        if let metadataObject = metadataObjects.first{
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue)
            
        }*/
        
        for metadata in metadataObjects
        {
            let decode:AVMetadataMachineReadableCodeObject = metadata as! AVMetadataMachineReadableCodeObject
            outputLabel.text = decode.stringValue
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        if (captureSession?.isRunning == true)
        {
            captureSession.stopRunning()
            captureSession = nil
        }
        self.previewLayer!.removeFromSuperlayer()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true)
        {
            captureSession.stopRunning()
            captureSession = nil
        }
    }
    
    
    
    func found(code: String)
    {
        print(code)
        view.layer.removeFromSuperlayer()
        captureSession.stopRunning()
        outputLabel.text = code
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

