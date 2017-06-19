                           %% ST
                        
% Proyect: Keyboard sounds recognition.

%% This script is aiming to extract features through the MFCC 
% (Mel-Frequency Cepstral Coefficients) parameters.
clear all; close all; clc;

    %% Define variables
    
    Tw = 10;                % analysis frame duration (ms)
    Ts = 2.5;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 32;                 % number of filterbank channels 
    C = 13;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 400;               % lower frequency limit (Hz)
    HF = 12000;              % upper frequency limit (Hz)
    
    %% Extract features
    for i = 1:100
        % Read speech samples, sampling rate and precision from file
        file=['A' num2str(i) '.wav'];
        [ speech, fs, nbits ] = wavread(file);

        % Feature extraction (feature vectors as columns)
        [ MFCCs, FBEs, frames ] = mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
        features=reshape(MFCCs,182,1);
        v_features_A(i,:)=features;
    end

    %% Generate data needed for plotting 
    %
    [ Nw, NF ] = size( frames );                % frame length and number of frames
    time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
    time = [ 0:length(speech)-1 ]/fs;           % time vector (s) for signal samples 
    logFBEs = 20*log10( FBEs );                 % compute log FBEs for plotting
    logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 50 dB below max
    logFBEs( logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range


    %% Generate plots
    %
    figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ... 
              'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 

    subplot( 311 );
    plot( time, speech, 'k' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Amplitude' ); 
    title( 'Speech waveform'); 

    subplot( 312 );
    imagesc( time_frames, [1:M], logFBEs ); 
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Channel index' ); 
    title( 'Log (mel) filterbank energies'); 

    subplot( 313 );
    imagesc( time_frames, [1:C], MFCCs(2:end,:) ); % HTK's TARGETKIND: MFCC
    %imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Cepstrum index' );
    title( 'Mel frequency cepstrum' );

    % Set color map to grayscale
    colormap( 1-colormap('gray') ); 

    % Print figure to pdf and png files
    print('-dpdf', sprintf('%s.pdf', mfilename)); 
    print('-dpng', sprintf('%s.png', mfilename));
    %}
    