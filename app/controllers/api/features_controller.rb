class Api::FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :create_comment]

  def index
    # Obtener los parámetros de paginación
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 25

    # Obtener los parámetros de consulta
    mag_types = params[:mag_types].split(",") if params[:mag_types]

    # Filtrar por mag_type si mag_types está presente
    features = mag_types.present? ? Feature.where(mag_type: mag_types) : Feature.all

    # Filtrar por mag_type
    features = Feature.where(mag_type: mag_types)

    # Paginar los resultados después de filtrar por mag_type
    features = Feature.paginate(page: page, per_page: per_page)

    @features = features.map do |feature|
      {
        id: feature.id,
        type: 'feature',
        attributes: {
          external_id: feature.external_id,
          magnitude: feature.magnitude,
          place: feature.place,
          time: feature.time,
          tsunami: feature.tsunami,
          mag_type: feature.mag_type,
          title: feature.title,
          coordinates: {
            longitude: feature.longitude,
            latitude: feature.latitude
          }
        },
        links: {
          external_url: feature.url
        }
      }
    end

    # Definir los diferentes tipos de magnitud predefinidos
    different_mag_types = Feature.distinct.pluck(:mag_type)

    render json: {
      data: @features,
      pagination: {
        current_page: features.current_page,
        total: features.total_entries,
        per_page: features.per_page
      },
      mag_types: different_mag_types
    }
  end

  def show
    render json: @feature
  end

  # POST /api/features/:id/create_comment
  def create_comment
    @comment = @feature.comments.build(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  # Método para buscar y configurar el feature asociado al comentario
  def set_feature
    @feature = Feature.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
