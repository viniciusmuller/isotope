// TODO: Decrease repeated code by figuring out how to
// pass the NoiseWrapper struct to functions

use bracket_noise::prelude::{
    CellularDistanceFunction, CellularReturnType, FastNoise, FractalType, Interp, NoiseType,
};
use rustler::resource::ResourceArc;
use rustler::{Atom, Env, NifStruct, Term};

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
#[module = "Isotope.Options"]
struct NoiseOptions {
    noise_type: NifNoiseType,
    interpolation: NifInterpolationType,
    cellular_options: CellularOptions,
    fractal_options: FractalOption,
    frequency: f32,
    seed: u64,
}

#[derive(NifStruct)]
#[module = "Isotope.Options.Cellular"]
struct CellularOptions {
    distance_function: Atom,
    return_type: Atom,
    distance_indices: (i32, i32),
    jitter: f32,
}

#[derive(NifStruct)]
#[module = "Isotope.Options.Fractal"]
struct FractalOption {
    fractal_type: NifFractalType,
    lacunarity: f32,
    octaves: i32,
    gain: f32,
}

#[rustler::nif]
fn get_noise(noise: ResourceArc<NoiseWrapper>, x: f32, y: f32) -> f32 {
    // FIXME: Hardcoded values
    noise.noise.get_noise(x / 160.0, y / 100.0)
}

#[rustler::nif]
fn get_noise3d(noise: ResourceArc<NoiseWrapper>, x: f32, y: f32, z: f32) -> f32 {
    // FIXME: Hardcoded values
    noise.noise.get_noise3d(x / 160.0, y / 100.0, z / 100.0)
}

// TODO: Maybe use DirtyIo //
#[rustler::nif]
fn noise_map(noise: ResourceArc<NoiseWrapper>, width: u64, height: u64) -> NoiseMap {
    internal_chunk(noise, 0, 0, width, height)
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

fn internal_chunk(
    noise: ResourceArc<NoiseWrapper>,
    px: i64,
    py: i64,
    width: u64,
    height: u64,
) -> NoiseMap {
    let mut noisemap = Vec::with_capacity(width as usize);

    for y in 0..height {
        let mut axis = Vec::with_capacity(height as usize);
        for x in 0..width {
            let point = noise.noise.get_noise(
                ((px + (x as i64)) as f32) / 160.0,
                ((py + (y as i64)) as f32) / 100.0,
            );

            axis.push(point);
        }
        noisemap.push(axis)
    }
    noisemap
}

#[rustler::nif]
fn chunk(noise: ResourceArc<NoiseWrapper>, px: i64, py: i64, width: u64, height: u64) -> NoiseMap {
    internal_chunk(noise, px, py, width, height)
}

rustler::init!(
    "Elixir.Isotope.NIF",
    [noise_map, chunk, get_noise, get_noise3d, new],
    load = load
);
