// TODO: Decrease repeated code by figuring out how to
// pass the NoiseWrapper struct to functions
// TODO: Add support to other library options on the elixir side.
use bracket_noise::prelude::{FastNoise, FractalType, NoiseType};
use rustler::resource::ResourceArc;
use rustler::{Atom, Env, NifMap, Term};
use std::path::Path;

rustler::atoms! {
    error, ok,
    // Noise types
    simplex, simplex_fractal, perlin, perlin_fractal,
    white, cubic, cubic_fractal, value, value_fractal,
    cellular,
    // fractal types
    fbm, rigid_multi, billow
}

type NifNoiseType = Atom;
type NifFractalType = Atom;
type NoiseMap = Vec<Vec<f32>>;

struct NoiseWrapper {
    // Could not find a way to implement rustler's ResourceTypeProvider on
    // the FastNoise, so atleast for now it will be wrapped into this struct.
    noise: FastNoise,
}

#[derive(NifMap)]
struct NoiseOptions {
    noise_type: NifNoiseType,
    fractal_type: NifFractalType,
    octaves: i32,
    gain: f32,
    lacunarity: f32,
    frequency: f32,
    seed: u64,
}

#[rustler::nif]
fn get_noise(noise: ResourceArc<NoiseWrapper>, x: f32, y: f32) -> f32 {
    noise.noise.get_noise(x / 160.0, y / 100.0)
}

// TODO: Maybe use DirtyIo //
#[rustler::nif]
fn noise_map(noise: ResourceArc<NoiseWrapper>, x: i64, y: i64) -> NoiseMap {
    let mut x_axis = Vec::with_capacity(x as usize);

    for i in 0..x {
        let mut y_axis = Vec::with_capacity(y as usize);
        for j in 0..y {
            y_axis.push(
                noise
                    .noise
                    .get_noise((i as f32) / 160.0, (j as f32) / 100.0),
            )
        }
        x_axis.push(y_axis);
    }
    x_axis
}

#[rustler::nif]
fn new(options: NoiseOptions) -> (Atom, ResourceArc<NoiseWrapper>) {
    let mut noise = FastNoise::seeded(options.seed);

    let noise_type = match options.noise_type {
        _ if options.noise_type == value() => NoiseType::Value,
        _ if options.noise_type == value_fractal() => NoiseType::ValueFractal,
        _ if options.noise_type == cubic() => NoiseType::Cubic,
        _ if options.noise_type == cubic_fractal() => NoiseType::CubicFractal,
        _ if options.noise_type == cellular() => NoiseType::Cellular,
        _ if options.noise_type == white() => NoiseType::WhiteNoise,
        _ if options.noise_type == perlin() => NoiseType::Perlin,
        _ if options.noise_type == perlin_fractal() => NoiseType::PerlinFractal,
        _ if options.noise_type == simplex() => NoiseType::Simplex,
        _ if options.noise_type == simplex_fractal() => NoiseType::SimplexFractal,
        _ => NoiseType::Simplex,
    };

    let fractal_type = match options.fractal_type {
        _ if options.fractal_type == fbm() => FractalType::FBM,
        _ if options.fractal_type == billow() => FractalType::Billow,
        _ if options.fractal_type == rigid_multi() => FractalType::RigidMulti,
        _ => FractalType::FBM,
    };

    noise.set_noise_type(noise_type);
    noise.set_fractal_type(fractal_type);
    noise.set_fractal_octaves(options.octaves);
    noise.set_fractal_gain(options.gain);
    noise.set_fractal_lacunarity(options.lacunarity);
    noise.set_frequency(options.frequency);

    let noise_struct = NoiseWrapper { noise };
    // TODO: Handle error
    (ok(), ResourceArc::new(noise_struct))
}

fn load(env: Env, _info: Term) -> bool {
    rustler::resource!(NoiseWrapper, env);
    true
}

#[rustler::nif]
fn chunk(noise: ResourceArc<NoiseWrapper>, sx: i64, sy: i64, ex: i64, ey: i64) -> NoiseMap {
    // TODO: Use vec with capacity later //
    let mut noisemap = Vec::new();

    let (greatest_x, minor_x) = if sx < ex { (ex, sx) } else { (sx, ex) };
    let (greatest_y, minor_y) = if sy < ey { (ey, sy) } else { (sy, ey) };

    for i in minor_y..(greatest_y + 1) {
        let mut x_axis = Vec::new();
        for j in minor_x..(greatest_x+1) {
            let point = noise
                .noise
                .get_noise((i as f32) / 160.0, (j as f32) / 100.0);
            x_axis.push(point);
        }
        noisemap.push(x_axis);
    }
    noisemap
}

#[rustler::nif]
fn write_to_file(noisemap: NoiseMap, filepath: &str) -> Result<Atom, (Atom, &str)> {
    let x = noisemap.len();
    let y = noisemap.first().unwrap().len();

    let mut pixels: Vec<u8> = Vec::with_capacity(x * y);

    for i in 0..x {
        for j in 0..y {
            pixels.push(((noisemap[i][j] * 0.5 + 0.5).clamp(0.0, 1.0) * 255.0) as u8);
        }
    }

    // TODO: enforce .png suffix
    let result = image::save_buffer(
        &Path::new(&filepath),
        &*pixels,
        x as u32,
        y as u32,
        image::ColorType::L8,
    );
    match result {
        Ok(_) => Ok(ok()),
        // TODO: Use error message here
        Err(_e) => Err((error(), "failed")),
    }
}

rustler::init!(
    "Elixir.Noisex.NIF",
    [noise_map, write_to_file, chunk, get_noise, new],
    load = load
);
