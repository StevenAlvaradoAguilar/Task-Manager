class Api::FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :create_comment]

  def index
    # Obtener los parámetros de paginación
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 25

    # Obtener los parámetros de consulta
    mag_types = params[:filters]&.dig(:mag_type) || []

    # Filtrar por mag_type
    features = Feature.where(mag_type: mag_types)

    # Paginar los resultados
    #features = features.offset((page - 1) * per_page).limit(per_page)

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

    render json: {
      data: @features,
      pagination: {
        current_page: features.current_page,
        total: features.total_entries,
        per_page: features.per_page
      }
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
