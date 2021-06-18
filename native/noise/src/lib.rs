// TODO: Decrease repeated code by figuring out how to
// pass the NoiseWrapper struct to functions
// TODO: Support 3d noises

use bracket_noise::prelude::{
    CellularDistanceFunction, CellularReturnType, FastNoise, FractalType, Interp, NoiseType,
};
use rustler::resource::ResourceArc;
use rustler::{Atom, Env, NifStruct, Term};
use std::path::Path;

rustler::atoms! {
    // Noise types
    simplex, simplex_fractal, perlin, perlin_fractal,
    white, cubic, cubic_fractal, value, value_fractal,
    cellular,
    // Fractal types
    fbm, rigid_multi, billow,
    // Interpolation types
    linear, hermite, quintic,
    // Cellular distance functions
    euclidean, manhattan, natural,
    // Cellular return type
    cell_value, distance, distance2, distance2add,
    distance2sub, distance2mul, distance2div,
    // Others
    error, ok, wrote
}

type NifNoiseType = Atom;
type NifFractalType = Atom;
type NifInterpolationType = Atom;

type NoiseMap = Vec<Vec<f32>>;

struct NoiseWrapper {
    // Could not find a way to implement rustler's ResourceTypeProvider on
    // the FastNoise, so atleast for now it will be wrapped into this struct.
    noise: FastNoise,
}

#[derive(NifStruct)]
#[module = "Noisex.Options"]
struct NoiseOptions {
    noise_type: NifNoiseType,
    interpolation: NifInterpolationType,
    cellular_options: CellularOptions,
    fractal_options: FractalOption,
    frequency: f32,
    seed: u64,
}

#[derive(NifStruct)]
#[module = "Noisex.Options.Cellular"]
struct CellularOptions {
    distance_function: Atom,
    return_type: Atom,
    distance_indices: (i32, i32),
    jitter: f32,
}

#[derive(NifStruct)]
#[module = "Noisex.Options.Fractal"]
struct FractalOption {
    fractal_type: NifFractalType,
    lacunarity: f32,
    octaves: i32,
    gain: f32,
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
    let cellular_opt = options.cellular_options;
    let fractal_opt = options.fractal_options;

    let noise_type = get_noise_type(options.noise_type);
    let interpolation = get_interpolation(options.interpolation);
    noise.set_interp(interpolation);
    noise.set_noise_type(noise_type);
    noise.set_frequency(options.frequency);

    let fractal_type = get_fractal_type(fractal_opt.fractal_type);
    noise.set_fractal_gain(fractal_opt.gain);
    noise.set_fractal_type(fractal_type);
    noise.set_fractal_octaves(fractal_opt.octaves);
    noise.set_fractal_lacunarity(fractal_opt.lacunarity);

    let distance_function = get_distance_function(cellular_opt.distance_function);
    let return_type = get_cellular_return_type(cellular_opt.return_type);
    noise.set_cellular_jitter(cellular_opt.jitter);
    noise.set_cellular_return_type(return_type);
    noise.set_cellular_distance_indices(
        cellular_opt.distance_indices.0,
        cellular_opt.distance_indices.1,
    );
    noise.set_cellular_distance_function(distance_function);

    let noise_struct = NoiseWrapper { noise };
    // TODO: Handle error
    (ok(), ResourceArc::new(noise_struct))
}

fn load(env: Env, _info: Term) -> bool {
    rustler::resource!(NoiseWrapper, env);
    true
}

fn get_fractal_type(atom: Atom) -> FractalType {
    match atom {
        _ if atom == fbm() => FractalType::FBM,
        _ if atom == billow() => FractalType::Billow,
        _ if atom == rigid_multi() => FractalType::RigidMulti,
        _ => FractalType::FBM,
    }
}

fn get_distance_function(atom: Atom) -> CellularDistanceFunction {
    match atom {
        _ if atom == euclidean() => CellularDistanceFunction::Euclidean,
        _ if atom == manhattan() => CellularDistanceFunction::Manhattan,
        _ if atom == natural() => CellularDistanceFunction::Natural,
        _ => CellularDistanceFunction::Euclidean,
    }
}

fn get_cellular_return_type(atom: Atom) -> CellularReturnType {
    match atom {
        _ if atom == cell_value() => CellularReturnType::CellValue,
        _ if atom == distance() => CellularReturnType::Distance,
        _ if atom == distance2() => CellularReturnType::Distance2,
        _ if atom == distance2add() => CellularReturnType::Distance2Add,
        _ if atom == distance2sub() => CellularReturnType::Distance2Sub,
        _ if atom == distance2mul() => CellularReturnType::Distance2Mul,
        _ if atom == distance2div() => CellularReturnType::Distance2Div,
        _ => CellularReturnType::CellValue,
    }
}

fn get_interpolation(atom: NifInterpolationType) -> Interp {
    match atom {
        _ if atom == linear() => Interp::Linear,
        _ if atom == hermite() => Interp::Hermite,
        _ if atom == quintic() => Interp::Quintic,
        _ => Interp::Quintic,
    }
}

fn get_noise_type(atom: Atom) -> NoiseType {
    match atom {
        _ if atom == value() => NoiseType::Value,
        _ if atom == value_fractal() => NoiseType::ValueFractal,
        _ if atom == cubic() => NoiseType::Cubic,
        _ if atom == cubic_fractal() => NoiseType::CubicFractal,
        _ if atom == cellular() => NoiseType::Cellular,
        _ if atom == white() => NoiseType::WhiteNoise,
        _ if atom == perlin() => NoiseType::Perlin,
        _ if atom == perlin_fractal() => NoiseType::PerlinFractal,
        _ if atom == simplex() => NoiseType::Simplex,
        _ if atom == simplex_fractal() => NoiseType::SimplexFractal,
        _ => NoiseType::Simplex,
    }
}

#[rustler::nif]
fn chunk(noise: ResourceArc<NoiseWrapper>, sx: i64, sy: i64, ex: i64, ey: i64) -> NoiseMap {
    // TODO: Use vec with capacity later //
    let mut noisemap = Vec::new();

    let (greatest_x, minor_x) = if sx < ex { (ex, sx) } else { (sx, ex) };
    let (greatest_y, minor_y) = if sy < ey { (ey, sy) } else { (sy, ey) };

    for i in minor_y..(greatest_y + 1) {
        let mut x_axis = Vec::new();
        for j in minor_x..(greatest_x + 1) {
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
fn write_to_file(noisemap: NoiseMap, filepath: &str) -> Result<Atom, String> {
    let x = noisemap.len();
    let y = noisemap.first().unwrap().len();

    let mut pixels: Vec<u8> = Vec::with_capacity(x * y);

    for x in noisemap.iter() {
        for y in x.iter() {
            pixels.push(((y * 0.5 + 0.5).clamp(0.0, 1.0) * 255.0) as u8);
        }
    }

    let result = image::save_buffer(
        &Path::new(&filepath),
        &*pixels,
        x as u32,
        y as u32,
        image::ColorType::L8,
    );
    match result {
        Ok(_) => Ok(wrote()),
        Err(e) => Err(e.to_string()),
    }
}

rustler::init!(
    "Elixir.Noisex.NIF",
    [noise_map, write_to_file, chunk, get_noise, new],
    load = load
);
