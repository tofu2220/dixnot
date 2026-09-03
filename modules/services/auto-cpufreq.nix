{
  nixpkgs.overlays = [
    (final: _prev: {
      auto-cpufreq = final.unstable.auto-cpufreq;
    })
  ];

  services.auto-cpufreq.enable = true;
}
